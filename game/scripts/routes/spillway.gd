extends Node2D
## The Spillway (Phase 6): the vertical slice's mood centerpiece. A huge
## concrete drainage canal at dusk; Eli films his trick in front of The Mouth,
## the camcorder glitches (first anomaly), Rina's walkie picks up a tone, and
## Eli goes into the tunnel. Geometry is code-built graybox like the other
## routes, but this scene also carries the first mood-blocking pass: dusk
## palette, treeline silhouettes, fog, and the humming Mouth.

# Dusk palette (design doc §5, "Color worlds — Dusk").
const COL_SKY := Color(0.09, 0.08, 0.17)
const COL_EMBER := Color(0.38, 0.18, 0.11)
const COL_TREES := Color(0.045, 0.06, 0.06)
const COL_CONCRETE := Color(0.28, 0.3, 0.36)
const COL_BACK_WALL := Color(0.2, 0.22, 0.28)
const COL_WATER := Color(0.08, 0.12, 0.2, 0.8)
const COL_FOG := Color(0.55, 0.6, 0.78, 0.07)
const COL_MOUTH := Color(0.012, 0.012, 0.02)
const COL_MOUTH_RIM := Color(0.16, 0.17, 0.22)
const COL_PIPE := Color(0.42, 0.4, 0.36)
const COL_OBSTACLE := Color(0.45, 0.28, 0.28)
const COL_ELI := Color(0.9, 0.55, 0.25)

const FLOOR_Y := 309.0          # canal floor top edge (set by the bank slope)
const MOUTH_X := 3360.0         # center of the tunnel arch on the back wall
const ELI_POST_X := 2620.0      # where Eli waits / debriefs
const TRICK_FAR_X := 2860.0     # far end of his filmed run
const FILM_X := 2580.0          # the X the player films from

enum MissionPhase { FIND_ELI, FILM_TRICK, GLITCHING, DEBRIEF, FOLLOW, DONE }

@onready var _player: PlayerController = $Player

var _phase := MissionPhase.FIND_ELI
var _eli: Npc
var _camcorder: Camcorder
var _objective: Label
var _event_label: Label
var _glitch_timer := 0.0
var _trick_tween: Tween


func _ready() -> void:
	_build_mood()
	_build_canal()
	_build_eli()
	add_child(DialogueBox.new())
	_build_hud()
	_camcorder = _player.get_node("Camcorder")
	GameState.evidence_added.connect(_on_evidence_added)


func _process(delta: float) -> void:
	_objective.text = "OBJECTIVE: %s" % _current_objective()
	match _phase:
		MissionPhase.FIND_ELI:
			# Evidence check first so leaving and re-entering the scene
			# resumes past beats that already played this session.
			if GameState.has_evidence("elis_trick"):
				_begin_debrief()
			elif GameState.has_flag("spillway_briefed"):
				_begin_trick_run()
		MissionPhase.GLITCHING:
			_glitch_timer -= delta
			if _glitch_timer <= 0.0:
				_begin_debrief()
		MissionPhase.DEBRIEF:
			if GameState.has_flag("eli_going_in"):
				_eli_enters_mouth()


func _current_objective() -> String:
	match _phase:
		MissionPhase.FIND_ELI:
			return "find Eli down by The Mouth"
		MissionPhase.FILM_TRICK:
			return "film Eli's line — stand on the X, [C] camcorder, hold [E]"
		MissionPhase.GLITCHING:
			return "...what was that?"
		MissionPhase.DEBRIEF:
			return "talk to Eli"
		MissionPhase.FOLLOW:
			return "Eli went in. follow him into The Mouth"
	return ""


# --- Mission beats ------------------------------------------------------------


func _begin_trick_run() -> void:
	_phase = MissionPhase.FILM_TRICK
	_eli.dialogue = {"start": [
		{"speaker": "Eli", "text": "Rolling! X! Stand on the X!"},
	]}
	# Eli's filmed line: skate at The Mouth, pop the lip, come back. Loops
	# until the capture lands; the EvidenceTarget rides along on him.
	_trick_tween = create_tween().set_loops()
	_trick_tween.tween_property(_eli, "position:x", TRICK_FAR_X, 1.5) \
			.set_trans(Tween.TRANS_SINE)
	_trick_tween.parallel().tween_property(_eli, "position:y", FLOOR_Y - 46.0, 0.75) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_trick_tween.parallel().tween_property(_eli, "position:y", FLOOR_Y, 0.75) \
			.set_delay(0.75).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_trick_tween.tween_property(_eli, "position:x", ELI_POST_X, 1.5) \
			.set_trans(Tween.TRANS_SINE)


func _on_evidence_added(id: String) -> void:
	if id != "elis_trick" or _phase != MissionPhase.FILM_TRICK:
		return
	_phase = MissionPhase.GLITCHING
	_glitch_timer = 2.2
	if _trick_tween != null:
		_trick_tween.kill()
	create_tween().tween_property(_eli, "position",
			Vector2(ELI_POST_X, FLOOR_Y), 0.8)

	# The anomaly: viewfinder tears, a second Eli stands in the tunnel for a
	# breath, the birds know before anyone does, and channel six squeals.
	_camcorder.apply_glitch(1.2)
	_spawn_ghost_eli()
	_erupt_birds()
	_show_event("RINA'S WALKIE: a tone on channel six — then nothing.")
	GameState.set_flag("anomaly_witnessed")


func _begin_debrief() -> void:
	_phase = MissionPhase.DEBRIEF
	_eli.dialogue = {
		"start": [
			{"speaker": "Eli", "text": "Did you get it?! Tell me the battery didn't—"},
			{"speaker": "You", "text": "Eli. Rewind it."},
			{"speaker": "Eli", "text": "..."},
			{"speaker": "Eli", "text": "That's me. Standing in the tunnel. While I'm landing the trick out here."},
			{"speaker": "You", "text": "Rina said if the radio squeals, we go get her. It squealed."},
			{"speaker": "Eli", "text": "And miss the season finale? It's a camera glitch with great composition. I'm going in.", "set_flag": "eli_going_in"},
			{"speaker": "Eli", "text": "Keep the tape running. Legends, remember?"},
		],
	}


func _eli_enters_mouth() -> void:
	# He starts walking on his last line; the dialogue box rides over it.
	_phase = MissionPhase.FOLLOW
	_eli.dialogue = {"start": [
		{"speaker": "Eli", "text": "Season finale, baby! Keep rolling!"},
	]}
	var walk := create_tween()
	walk.tween_property(_eli, "position:x", MOUTH_X, 2.6)
	walk.parallel().tween_property(_eli, "modulate:a", 0.0, 2.6) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	walk.tween_callback(func() -> void:
		GameState.set_flag("eli_entered_mouth")
		_eli.queue_free())


func _on_mouth_entered(body: Node2D) -> void:
	if body != _player or _phase == MissionPhase.DONE:
		return
	if _phase == MissionPhase.FOLLOW and GameState.has_flag("eli_entered_mouth"):
		_end_card()
	else:
		_show_event("(pitch black inside. the hum has a pulse. not yet.)")


func _end_card() -> void:
	_phase = MissionPhase.DONE
	GameState.set_flag("mission_spillway_done")
	_player.begin_interaction()

	var layer := CanvasLayer.new()
	layer.layer = 80
	add_child(layer)
	var black := ColorRect.new()
	black.color = Color(0, 0, 0, 0)
	black.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(black)

	var title := Label.new()
	title.text = "You step into The Mouth after Eli.\n\nTO BE CONTINUED — Phase 7: Tunnel Traversal"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_preset(Control.PRESET_CENTER)
	title.modulate = Color(1, 1, 1, 0)
	layer.add_child(title)

	var fade := create_tween()
	fade.tween_property(black, "color:a", 1.0, 1.4)
	fade.tween_property(title, "modulate:a", 1.0, 0.8)


# --- Anomaly dressing ---------------------------------------------------------


func _spawn_ghost_eli() -> void:
	var ghost := Polygon2D.new()
	ghost.color = Color(COL_ELI.r, COL_ELI.g, COL_ELI.b, 0.35)
	ghost.polygon = PackedVector2Array([
		Vector2(-11, -50), Vector2(11, -50), Vector2(11, 0), Vector2(-11, 0),
	])
	ghost.position = Vector2(MOUTH_X, FLOOR_Y)
	add_child(ghost)
	var t := create_tween()
	t.tween_interval(1.0)
	t.tween_property(ghost, "color:a", 0.0, 0.25)
	t.tween_callback(ghost.queue_free)


func _erupt_birds() -> void:
	for i in 6:
		var bird := Polygon2D.new()
		bird.color = Color(0.02, 0.02, 0.03)
		bird.polygon = PackedVector2Array([
			Vector2(-7, 3), Vector2(7, 3), Vector2(0, -5),
		])
		bird.position = Vector2(randf_range(2950.0, 3250.0), randf_range(-60.0, 10.0))
		add_child(bird)
		var t := create_tween()
		t.tween_property(bird, "position", bird.position
				+ Vector2(randf_range(-300.0, -120.0), randf_range(-420.0, -280.0)),
				randf_range(1.2, 1.8)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		t.parallel().tween_property(bird, "modulate:a", 0.0, 1.6)
		t.tween_callback(bird.queue_free)


func _show_event(text: String) -> void:
	_event_label.text = text
	_event_label.modulate.a = 1.0
	var t := create_tween()
	t.tween_interval(4.0)
	t.tween_property(_event_label, "modulate:a", 0.0, 1.2)


# --- Layout -------------------------------------------------------------------


func _build_canal() -> void:
	# Street-level approach, then a long skateable bank into the canal floor.
	var p := Vector2(-300, 0)
	p = _segment(p, 0.0, 760.0, COL_CONCRETE, "Spillway access")
	p = _segment(p, 18.0, 1000.0, COL_CONCRETE, "The bank")
	p = _segment(p, 0.0, 2200.0, COL_CONCRETE, "")

	# Clean ends.
	_box(Vector2(-340, -150), Vector2(40, 300), COL_OBSTACLE)
	_box(Vector2(p.x + 20, p.y - 170), Vector2(40, 340), COL_OBSTACLE)

	# Standing water: visual strips on the floor (the wet feel is Phase 7's).
	for water_x: float in [1750.0, 2880.0]:
		var w := _rect_poly(Vector2(380, 7), COL_WATER)
		w.position = Vector2(water_x, FLOOR_Y + 4.0)
		w.z_index = -2
		add_child(w)

	# A drain pipe to grind along the back wall.
	var rail: GrindRail = preload("res://scenes/rails/GrindRail.tscn").instantiate()
	rail.position = Vector2(1820, FLOOR_Y - 38.0)
	rail.end_point = Vector2(520, 0)
	rail.color = COL_PIPE
	add_child(rail)

	_decor(Vector2(560, -64), Vector2(110, 70), Color(0.5, 0.42, 0.2),
			"CEDAR RIFT WATER AUTHORITY — NO TRESPASSING")
	_decor(Vector2(3120, FLOOR_Y - 55.0), Vector2(52, 110), Color(0.16, 0.18, 0.24),
			"service door")
	_decor(Vector2(FILM_X, FLOOR_Y - 4.0), Vector2(34, 8), Color(0.9, 0.8, 0.3),
			"X — film from here")

	_build_mouth()

	var gate := SceneGate.new()
	gate.target_scene = "res://scenes/routes/MercyHill.tscn"
	gate.label_text = "Back to town"
	gate.position = Vector2(-240, 0)
	add_child(gate)


func _build_mouth() -> void:
	# The Mouth: a huge black arch in the back wall. Pure dark, faint rim,
	# and a glow that pulses like breathing — the hum, drawn instead of heard.
	var rim := _arch_poly(170.0, 250.0, COL_MOUTH_RIM)
	rim.position = Vector2(MOUTH_X, FLOOR_Y)
	rim.z_index = -5
	add_child(rim)

	var dark := _arch_poly(140.0, 220.0, COL_MOUTH)
	dark.position = Vector2(MOUTH_X, FLOOR_Y)
	dark.z_index = -4
	add_child(dark)

	var glow := _arch_poly(110.0, 180.0, Color(0.1, 0.07, 0.16, 0.0))
	glow.position = Vector2(MOUTH_X, FLOOR_Y)
	glow.z_index = -3
	add_child(glow)
	var pulse := create_tween().set_loops()
	pulse.tween_property(glow, "color:a", 0.5, 1.6).set_trans(Tween.TRANS_SINE)
	pulse.tween_property(glow, "color:a", 0.0, 1.6).set_trans(Tween.TRANS_SINE)

	var hum := Label.new()
	hum.text = "( the tunnel hums )"
	hum.position = Vector2(MOUTH_X - 70.0, FLOOR_Y - 290.0)
	hum.modulate = Color(1, 1, 1, 0.35)
	add_child(hum)

	var zone := Area2D.new()
	zone.position = Vector2(MOUTH_X, FLOOR_Y - 80.0)
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(150, 160)
	shape.shape = rect
	zone.add_child(shape)
	zone.body_entered.connect(_on_mouth_entered)
	add_child(zone)


func _build_mood() -> void:
	# Sky, ember horizon, and treeline silhouettes — all far behind play.
	var sky := _rect_poly(Vector2(5200, 1700), COL_SKY)
	sky.position = Vector2(1700, -350)
	sky.z_index = -20
	add_child(sky)

	var ember := _rect_poly(Vector2(5200, 160), COL_EMBER)
	ember.position = Vector2(1700, -160)
	ember.z_index = -19
	add_child(ember)

	# Back canal wall the arch lives in.
	var wall := _rect_poly(Vector2(2400, 360), COL_BACK_WALL)
	wall.position = Vector2(2380, FLOOR_Y - 180.0)
	wall.z_index = -8
	add_child(wall)

	# Graffiti on the back wall: the kids were here first.
	for g: Array in [
		[Vector2(1620, FLOOR_Y - 70.0), Vector2(120, 46), Color(0.5, 0.3, 0.5, 0.55), "CR '86"],
		[Vector2(2200, FLOOR_Y - 90.0), Vector2(170, 60), Color(0.25, 0.5, 0.5, 0.55), "SKATE THE DRAIN"],
		[Vector2(2760, FLOOR_Y - 64.0), Vector2(140, 40), Color(0.55, 0.5, 0.25, 0.5), "IT LISTENS"],
	]:
		var tag := _rect_poly(g[1], g[2])
		tag.position = g[0]
		tag.z_index = -7
		add_child(tag)
		var l := Label.new()
		l.text = g[3]
		l.position = g[0] + Vector2(-g[1].x * 0.4, -12.0)
		l.modulate = Color(1, 1, 1, 0.4)
		l.z_index = -7
		add_child(l)

	# Jagged treeline above the canal rim.
	for ridge: Array in [[-300.0, 1500.0, -60.0], [2300.0, 3700.0, -40.0]]:
		add_child(_treeline(ridge[0], ridge[1], ridge[2]))

	# Low fog over the floor, drifting slowly.
	for i in 3:
		var fog := _rect_poly(Vector2(900, 60), COL_FOG)
		fog.position = Vector2(1500.0 + i * 700.0, FLOOR_Y - 24.0)
		fog.z_index = 8
		add_child(fog)
		var drift := create_tween().set_loops()
		drift.tween_property(fog, "position:x", fog.position.x + 70.0, 8.0 + i * 2.0) \
				.set_trans(Tween.TRANS_SINE)
		drift.tween_property(fog, "position:x", fog.position.x, 8.0 + i * 2.0) \
				.set_trans(Tween.TRANS_SINE)

	# Dusk grade over the whole scene.
	var grade := CanvasModulate.new()
	grade.color = Color(0.84, 0.84, 1.0)
	add_child(grade)


func _treeline(from_x: float, to_x: float, base_y: float) -> Polygon2D:
	var pts := PackedVector2Array([Vector2(from_x, base_y)])
	var x := from_x
	while x < to_x:
		var peak_h := randf_range(60.0, 130.0)
		var step := randf_range(50.0, 110.0)
		pts.append(Vector2(x + step * 0.5, base_y - peak_h))
		pts.append(Vector2(x + step, base_y - randf_range(10.0, 30.0)))
		x += step
	pts.append(Vector2(to_x, base_y))
	pts.append(Vector2(to_x, base_y + 40.0))
	pts.append(Vector2(from_x, base_y + 40.0))
	var poly := Polygon2D.new()
	poly.color = COL_TREES
	poly.polygon = pts
	poly.z_index = -15
	return poly


func _build_eli() -> void:
	_eli = Npc.new()
	_eli.npc_id = "eli"
	_eli.npc_name = "Eli"
	_eli.color = COL_ELI
	_eli.position = Vector2(ELI_POST_X, FLOOR_Y)
	_eli.dialogue = {
		"start": [
			{"speaker": "Eli", "text": "There you are! Light's almost gone. That's good — fear sells tapes."},
			{"speaker": "Eli", "text": "One run: down the bank, pop the lip, land it right in front of The Mouth. You film from the X. Don't cut early."},
			{"choice": [
				{"text": "Why here?", "goto": "why"},
				{"text": "Roll tape.", "goto": "roll"},
			]},
		],
		"why": [
			{"speaker": "Eli", "text": "Because Cal says nobody skates the Spillway. That's free marketing."},
			{"speaker": "You", "text": "Cal says the tunnel hums."},
			{"speaker": "Eli", "text": "Everything hums if you listen long enough. Drains. Fridges. Dad's truck."},
			{"goto": "roll"},
		],
		"roll": [
			{"speaker": "Eli", "text": "Battery's blinking, so: one take. Make me look taller than I am.", "set_flag": "spillway_briefed"},
		],
	}
	add_child(_eli)

	var trick := EvidenceTarget.new()
	trick.evidence_id = "elis_trick"
	trick.display_name = "Eli's line at The Mouth"
	trick.show_visual = false
	trick.position = Vector2(0, -25)
	_eli.add_child(trick)


# --- Builders (per-route, same style as Mercy Hill) ---------------------------


func _segment(start: Vector2, angle_deg: float, length: float, color: Color,
		label := "", one_way := false, thickness := 40.0) -> Vector2:
	var angle := deg_to_rad(angle_deg)
	var dir := Vector2(cos(angle), sin(angle))
	var down := Vector2(-dir.y, dir.x)

	var body := StaticBody2D.new()
	body.position = start + dir * length * 0.5 + down * thickness * 0.5
	body.rotation = angle

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(length, thickness)
	shape.shape = rect
	shape.one_way_collision = one_way
	body.add_child(shape)
	body.add_child(_rect_poly(Vector2(length, thickness), color))

	if label != "":
		var l := Label.new()
		l.text = label
		l.position = Vector2(-length * 0.5, -thickness * 0.5 - 30.0)
		l.modulate = Color(1, 1, 1, 0.45)
		body.add_child(l)

	add_child(body)
	return start + dir * length


func _box(center: Vector2, size: Vector2, color: Color) -> void:
	var body := StaticBody2D.new()
	body.position = center
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.add_child(shape)
	body.add_child(_rect_poly(size, color))
	add_child(body)


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


func _arch_poly(half_width: float, height: float, color: Color) -> Polygon2D:
	# A flat-bottomed arch: straight jambs up to the shoulder, semicircle on top.
	var shoulder := -(height - half_width)
	var pts := PackedVector2Array([
		Vector2(-half_width, 0), Vector2(-half_width, shoulder),
	])
	for i in range(1, 8):
		var a := PI - PI * i / 8.0
		pts.append(Vector2(cos(a) * half_width, shoulder - sin(a) * half_width))
	pts.append(Vector2(half_width, shoulder))
	pts.append(Vector2(half_width, 0))
	var poly := Polygon2D.new()
	poly.color = color
	poly.polygon = pts
	return poly


# --- HUD ----------------------------------------------------------------------


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var title := Label.new()
	title.text = "THE SPILLWAY — DUSK"
	title.position = Vector2(520, 14)
	layer.add_child(title)
	_objective = Label.new()
	_objective.position = Vector2(330, 40)
	_objective.modulate = Color(1.0, 0.85, 0.4)
	layer.add_child(_objective)
	_event_label = Label.new()
	_event_label.position = Vector2(330, 66)
	_event_label.modulate = Color(0.6, 0.9, 0.8, 0.0)
	layer.add_child(_event_label)
	var hint := Label.new()
	hint.text = "[W] push   [Space] ollie   [S] brake/grind   [F] walk   [C] camcorder   [E] talk/record   [R] reset"
	hint.position = Vector2(230, 690)
	hint.modulate = Color(1, 1, 1, 0.5)
	layer.add_child(hint)
