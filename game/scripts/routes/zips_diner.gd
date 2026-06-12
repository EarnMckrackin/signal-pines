extends Node2D
## Zip's Diner & Arcade (Phase 4): graybox interior, the crew, the deputy,
## and the Northstar flyer (Phase 5 camcorder target). Each route keeps its
## own small mission flow; extract a shared controller only if they converge.

const COL_FLOOR := Color(0.3, 0.27, 0.24)
const COL_WALL := Color(0.16, 0.14, 0.16)
const COL_BACKDROP := Color(0.11, 0.1, 0.12)
const COL_COUNTER := Color(0.5, 0.35, 0.25)
const COL_ARCADE := Color(0.3, 0.2, 0.45)
const COL_BOARD := Color(0.35, 0.25, 0.18)

const CREW := ["eli", "rina", "cal", "june"]

@onready var _player: PlayerController = $Player

var _objective: Label


func _ready() -> void:
	_player.set_on_foot()
	_build_room()
	_build_cast()
	add_child(DialogueBox.new())
	_build_hud()


func _process(_delta: float) -> void:
	_objective.text = "OBJECTIVE: %s" % _current_objective()


func _current_objective() -> String:
	var talked := 0
	for id in CREW:
		if GameState.has_flag("talked_" + id):
			talked += 1
	if talked < CREW.size():
		return "talk to the crew (%d/4)" % talked
	if not GameState.has_evidence("northstar_flyer"):
		if GameState.has_flag("has_camcorder"):
			return "film the Northstar flyer on the corkboard — [C] raises the camcorder"
		return "talk to Eli about the camcorder"
	GameState.set_flag("mission_zips_done")
	return "got it. head back out when you're ready"


# --- Room -------------------------------------------------------------------


func _build_room() -> void:
	_backdrop(Vector2(675, -140), Vector2(1650, 280))
	_floor_body(Vector2(675, 20), Vector2(1650, 40))
	_wall(Vector2(-130, -140))
	_wall(Vector2(1480, -140))

	# Dressing (visual only, so nobody gets stuck on a barstool).
	_decor(Vector2(350, -30), Vector2(260, 60), COL_COUNTER, "counter")
	_decor(Vector2(1020, -45), Vector2(60, 90), COL_ARCADE, "")
	_decor(Vector2(1095, -45), Vector2(60, 90), COL_ARCADE, "arcade")
	_decor(Vector2(1280, -115), Vector2(96, 76), COL_BOARD, "community board")

	var flyer := EvidenceTarget.new()
	flyer.evidence_id = "northstar_flyer"
	flyer.display_name = "Northstar flyer"
	flyer.position = Vector2(1280, -112)
	add_child(flyer)

	var gate := SceneGate.new()
	gate.target_scene = "res://scenes/routes/MercyHill.tscn"
	gate.label_text = "Back outside"
	gate.position = Vector2(-60, 0)
	add_child(gate)


func _build_cast() -> void:
	_npc("cal", "Cal", Color(0.35, 0.6, 0.5), Vector2(180, 0), {
		"start": [
			{"speaker": "Cal", "text": "Heard you didn't eat it on Mercy Hill. Congratulations. That's the easy line."},
			{"speaker": "Cal", "text": "The real line ends at the Spillway. Nobody skates past The Mouth after dark, though.", "set_flag": "rumor_mouth"},
			{"speaker": "You", "text": "Why not?"},
			{"speaker": "Cal", "text": "Because nobody does. Rules around here are load-bearing."},
		],
	})
	_npc("deputy", "Deputy Boyd", Color(0.45, 0.45, 0.55), Vector2(400, 0), {
		"start": [
			{"speaker": "Deputy Boyd", "text": "Counter's for paying customers, kid."},
			{"speaker": "Deputy Boyd", "text": "Curfew's ten o'clock now. Town council says it's about the bears.", "set_flag": "rumor_curfew"},
			{"speaker": "You", "text": "...Bears?"},
			{"speaker": "Deputy Boyd", "text": "Bears."},
		],
	})
	_npc("eli", "Eli", Color(0.9, 0.55, 0.25), Vector2(560, 0), {
		"start": [
			{"speaker": "Eli", "text": "Finally! I've been workshopping the intro narration all day. 'Cedar Rift: a town with secrets—'"},
			{"speaker": "You", "text": "You said that about the sewer raccoon documentary."},
			{"speaker": "Eli", "text": "And WAS I wrong? Okay. Listen. Tonight. The Spillway. One good tape and we're legends."},
			{"choice": [
				{"text": "What's at the Spillway?", "goto": "spillway"},
				{"text": "I'm in.", "goto": "camcorder"},
			]},
		],
		"spillway": [
			{"speaker": "Eli", "text": "The Mouth. Big drain tunnel, hums like a fridge. I say it's our season finale."},
			{"goto": "camcorder"},
		],
		"camcorder": [
			{"speaker": "Eli", "text": "Take the camcorder. You film, I skate. Don't fight the autofocus — it knows what it wants.", "set_flag": "has_camcorder"},
			{"speaker": "Eli", "text": "Battery's at half, so no artsy shots of streetlights this time. Practice on something. The corkboard's right there."},
		],
	})
	_npc("june", "June", Color(0.75, 0.4, 0.55), Vector2(740, 0), {
		"start": [
			{"speaker": "June", "text": "Three Northstar vans went up the mill road last night. The mill's been closed since March."},
			{"speaker": "June", "text": "No permits, no work orders — I checked the county logs. The paper runs my piece Friday, if Principal Dean doesn't kill it again.", "set_flag": "rumor_northstar_van"},
			{"speaker": "June", "text": "If you see a van, get the plate. Don't get seen."},
		],
	})
	_npc("rina", "Rina", Color(0.4, 0.55, 0.8), Vector2(940, 0), {
		"start": [
			{"speaker": "Rina", "text": "Hold this. Don't ask what it does."},
			{"speaker": "You", "text": "What does it—"},
			{"speaker": "Rina", "text": "It listens. Something near the storm drains keeps stepping on channel six. Same pulse, every ninety seconds.", "set_flag": "rumor_radio_pulse"},
			{"speaker": "Rina", "text": "If your walkie squeals tonight, do not be a hero. Come get me."},
		],
	})


# --- Builders ----------------------------------------------------------------


func _npc(id: String, npc_name: String, color: Color, pos: Vector2,
		dialogue: Dictionary) -> void:
	var n := Npc.new()
	n.npc_id = id
	n.npc_name = npc_name
	n.color = color
	n.dialogue = dialogue
	n.position = pos
	add_child(n)


func _floor_body(center: Vector2, size: Vector2) -> void:
	var body := StaticBody2D.new()
	body.position = center
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.add_child(shape)
	body.add_child(_rect_poly(size, COL_FLOOR))
	add_child(body)


func _wall(center: Vector2) -> void:
	var body := StaticBody2D.new()
	body.position = center
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(40, 320)
	shape.shape = rect
	body.add_child(shape)
	body.add_child(_rect_poly(Vector2(40, 320), COL_WALL))
	add_child(body)


func _backdrop(center: Vector2, size: Vector2) -> void:
	var poly := _rect_poly(size, COL_BACKDROP)
	poly.position = center
	# Behind everything: the Player node sits earlier in the tree than this
	# code-built geometry, so without an explicit z it would be painted over.
	poly.z_index = -10
	add_child(poly)


func _decor(center: Vector2, size: Vector2, color: Color, label: String) -> void:
	var poly := _rect_poly(size, color)
	poly.position = center
	poly.z_index = -5
	add_child(poly)
	if label != "":
		var l := Label.new()
		l.text = label
		l.position = center + Vector2(-size.x * 0.5, -size.y * 0.5 - 26.0)
		l.modulate = Color(1, 1, 1, 0.4)
		add_child(l)


func _rect_poly(size: Vector2, color: Color) -> Polygon2D:
	var poly := Polygon2D.new()
	poly.color = color
	var hw := size.x * 0.5
	var hh := size.y * 0.5
	poly.polygon = PackedVector2Array([
		Vector2(-hw, -hh), Vector2(hw, -hh), Vector2(hw, hh), Vector2(-hw, hh),
	])
	return poly


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var title := Label.new()
	title.text = "ZIP'S DINER & ARCADE"
	title.position = Vector2(480, 14)
	layer.add_child(title)
	_objective = Label.new()
	_objective.position = Vector2(330, 40)
	_objective.modulate = Color(1.0, 0.85, 0.4)
	layer.add_child(_objective)
	var hint := Label.new()
	hint.text = "[A/D] walk   [E] talk / record   [C] camcorder   [Space] jump   [F] board"
	hint.position = Vector2(310, 690)
	hint.modulate = Color(1, 1, 1, 0.5)
	layer.add_child(hint)
