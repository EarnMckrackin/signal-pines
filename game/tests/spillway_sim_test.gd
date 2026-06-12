extends Node
## Headless smoke test for Phase 6: arrives at the Spillway with the camcorder
## (Zip's flags pre-set), talks Eli through the briefing, films his trick from
## the X, rides out the glitch, debriefs, and follows him into The Mouth.
## Run with:
##   Godot --headless --path game res://tests/SpillwaySimTest.tscn

const FILM_SPOT := Vector2(2580, 282)
const ELI_SIDE := Vector2(45, -27)
const MOUTH_SPOT := Vector2(3360, 282)

var route: Node2D
var player: PlayerController
var dbox: DialogueBox


func _ready() -> void:
	# Arrive as if Zip's already played: camcorder in hand, mission done.
	GameState.set_flag("has_camcorder")
	GameState.set_flag("mission_zips_done")
	route = load("res://scenes/routes/Spillway.tscn").instantiate()
	add_child(route)
	player = route.get_node("Player")
	_run()


func _run() -> void:
	await _wait(0.5)
	dbox = get_tree().get_first_node_in_group("dialogue_box")

	# Briefing: talk to Eli, page through (first choice on the branch).
	var eli := _find_npc("eli")
	await _talk_through(eli)
	print("briefed -> %s" % GameState.has_flag("spillway_briefed"))

	# Film the trick: stand on the X facing Eli's run, raise, hold [E].
	player.global_position = FILM_SPOT
	player.velocity = Vector2.ZERO
	player.facing = 1
	await _wait(0.4)
	await _tap("camcorder")
	await _wait(0.3)
	_send("interact", true)
	var guard := 0
	while not GameState.has_evidence("elis_trick") and guard < 60:
		await _wait(0.1)
		guard += 1
	_send("interact", false)
	print("trick captured -> %s (%.1fs held)" % [
		GameState.has_evidence("elis_trick"), guard * 0.1])

	# Ride out the glitch, then lower the camcorder and debrief.
	await _wait(3.0)
	await _tap("camcorder")
	await _wait(0.3)
	await _talk_through(eli)
	print("eli going in -> %s" % GameState.has_flag("eli_going_in"))

	# Wait for Eli's walk into the tunnel, then follow him.
	guard = 0
	while not GameState.has_flag("eli_entered_mouth") and guard < 80:
		await _wait(0.1)
		guard += 1
	player.global_position = MOUTH_SPOT
	player.velocity = Vector2.ZERO
	await _wait(0.6)
	_report()


func _report() -> void:
	var checks := {
		"spillway_briefed": GameState.has_flag("spillway_briefed"),
		"trick_captured": GameState.has_evidence("elis_trick"),
		"anomaly_witnessed": GameState.has_flag("anomaly_witnessed"),
		"eli_going_in": GameState.has_flag("eli_going_in"),
		"eli_entered_mouth": GameState.has_flag("eli_entered_mouth"),
		"mission_spillway_done": GameState.has_flag("mission_spillway_done"),
	}
	var ok := true
	var parts: Array[String] = []
	for key: String in checks:
		ok = ok and checks[key]
		parts.append("%s=%s" % [key, checks[key]])
	print("RESULT: %s  [%s]" % ["PASS" if ok else "FAIL", "  ".join(parts)])
	get_tree().quit(0 if ok else 1)


func _talk_through(npc: Npc) -> void:
	player.global_position = npc.global_position + ELI_SIDE
	player.velocity = Vector2.ZERO
	await _wait(0.3)
	await _tap("interact")
	await _wait(0.2)
	var guard := 0
	while dbox.visible and guard < 30:
		await _tap("interact")
		await _wait(0.12)
		guard += 1


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
