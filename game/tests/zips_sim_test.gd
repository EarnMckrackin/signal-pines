extends Node
## Headless smoke test for Phase 4+5: walks to every NPC in Zip's, plays each
## conversation through (first choice on branches), then raises the camcorder
## and films the Northstar flyer. Run with:
##   Godot --headless --path game res://tests/ZipsSimTest.tscn

var route: Node2D
var player: PlayerController
var dbox: DialogueBox


func _ready() -> void:
	route = load("res://scenes/routes/ZipsDiner.tscn").instantiate()
	add_child(route)
	player = route.get_node("Player")
	_run()


func _run() -> void:
	await _wait(0.5)
	dbox = get_tree().get_first_node_in_group("dialogue_box")

	for id in ["cal", "deputy", "eli", "june", "rina"]:
		var npc := _find_npc(id)
		player.global_position = npc.global_position + Vector2(45, -27)
		player.velocity = Vector2.ZERO
		await _wait(0.3)
		await _tap("interact")
		await _wait(0.2)
		var guard := 0
		while dbox.visible and guard < 30:
			await _tap("interact")
			await _wait(0.12)
			guard += 1
		print("talked %-7s -> %s (pages pressed: %d)" % [
			id, GameState.has_flag("talked_" + id), guard])

	# Film the flyer: stand left of the corkboard, face right, raise, hold E.
	var flyer: EvidenceTarget = get_tree().get_first_node_in_group("evidence")
	player.global_position = flyer.global_position + Vector2(-120, 85)
	player.velocity = Vector2.ZERO
	player.facing = 1
	await _wait(0.4)
	await _tap("camcorder")
	await _wait(0.3)
	_send("interact", true)
	await _wait(2.0)
	_send("interact", false)
	await _wait(0.3)
	_report()


func _report() -> void:
	var checks := {
		"talked_all": ["cal", "deputy", "eli", "june", "rina"].all(
				func(id: String) -> bool: return GameState.has_flag("talked_" + id)),
		"rumor_mouth": GameState.has_flag("rumor_mouth"),
		"rumor_curfew": GameState.has_flag("rumor_curfew"),
		"rumor_northstar_van": GameState.has_flag("rumor_northstar_van"),
		"rumor_radio_pulse": GameState.has_flag("rumor_radio_pulse"),
		"has_camcorder": GameState.has_flag("has_camcorder"),
		"flyer_captured": GameState.has_evidence("northstar_flyer"),
		"mission_zips_done": GameState.has_flag("mission_zips_done"),
	}
	var ok := true
	var parts: Array[String] = []
	for key: String in checks:
		ok = ok and checks[key]
		parts.append("%s=%s" % [key, checks[key]])
	print("RESULT: %s  [%s]" % ["PASS" if ok else "FAIL", "  ".join(parts)])
	get_tree().quit(0 if ok else 1)


func _find_npc(id: String) -> Npc:
	for n: Npc in get_tree().get_nodes_in_group("npc"):
		if n.npc_id == id:
			return n
	return null


func _send(action: String, pressed: bool) -> void:
	# Input.action_press() from a timer callback lands after the frame's
	# _process pass, so is_action_just_pressed() never fires. Real input
	# events are flushed at the start of the next frame instead.
	var ev := InputEventAction.new()
	ev.action = action
	ev.pressed = pressed
	Input.parse_input_event(ev)


func _tap(action: String) -> void:
	_send(action, true)
	await get_tree().process_frame
	await get_tree().process_frame
	_send(action, false)
	await get_tree().process_frame


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
