extends Node2D
## Main Street line (slice connective route): the skate line from Zip's down to
## the Spillway. Graybox geometry built in code, same as Mercy Hill, so the
## layout stays cheap to retune. Uses only existing verbs — push/brake/ollie/
## grind/walk/camcorder — and adds no new systems. Tuned slow and readable first
## per docs/ITERATION_FRAMEWORK.md; tighten only after a human feel pass.

const COL_GROUND := Color(0.28, 0.3, 0.37)
const COL_OBSTACLE := Color(0.5, 0.28, 0.3)
const COL_RISKY := Color(0.8, 0.6, 0.22)
const COL_RAIL := Color(1.0, 0.9, 0.25)
const COL_VAN := Color(0.4, 0.42, 0.5)
const COL_STOREFRONT := Color(0.18, 0.18, 0.24)
const COL_DUSK := Color(0.16, 0.15, 0.22)

const START_LINE_X := 200.0

@onready var _player: PlayerController = $Player

var _objective: Label


func _ready() -> void:
	_build_atmosphere()
	_build_route()
	add_child(DialogueBox.new())
	_build_hud()


func _process(_delta: float) -> void:
	_objective.text = "OBJECTIVE: %s" % _current_objective()


func _current_objective() -> String:
	if GameState.has_evidence("northstar_plate"):
		return "plate filmed. skate Main Street to the Spillway"
	return "skate Main Street to the Spillway — film the van plate if you spot it"


# --- Mood -------------------------------------------------------------------


func _build_atmosphere() -> void:
	# Shared atmosphere system: parallax depth, particles, dusk grade. Replaces
	# the old flat dusk rectangle. Palette lives in RoutePalettes.
	var atmo := Atmosphere.new()
	atmo.config = RoutePalettes.main_street()
	add_child(atmo)


# --- Layout -----------------------------------------------------------------


func _build_route() -> void:
	# Safe line: one continuous floor from start to the Spillway approach.
	var p := Vector2(-300, 0)
	p = _segment(p, 0.0, 800.0, COL_GROUND, "Out front of Zip's")
	p = _segment(p, 8.0, 1200.0, COL_GROUND, "Main Street")
	var storefront_start := p
	p = _segment(p, 0.0, 1100.0, COL_GROUND, "Storefront row")
	p = _segment(p, 12.0, 1300.0, COL_GROUND, "The grade")
	p = _segment(p, 0.0, 1000.0, COL_GROUND, "Spillway approach")

	# End walls so the route reads as bounded.
	_box(Vector2(-340, -150), Vector2(40, 300), COL_OBSTACLE)
	_box(Vector2(p.x + 20, p.y - 150), Vector2(40, 300), COL_OBSTACLE)

	# Storefront backdrops (visual only) along the flat row.
	_decor(Vector2(storefront_start.x + 250, storefront_start.y - 150),
			Vector2(360, 220), COL_STOREFRONT, "")
	_decor(Vector2(storefront_start.x + 720, storefront_start.y - 130),
			Vector2(340, 180), COL_STOREFRONT, "")

	# One grind line: a handrail early in the row. No collision — hold brake in
	# the air near it to snap on; missing it drops to the safe line below.
	_grind_rail(Vector2(storefront_start.x + 120, storefront_start.y - 60),
			0.0, 600.0, "Rail (hold S in air to grind)")

	# Optional camcorder beat: a parked Northstar van + plate evidence target,
	# set into the storefronts. Never gates progress — payoff to June's "get the
	# plate" / Rina's storm-drain pulse.
	var van_x := storefront_start.x + 360
	_decor(Vector2(van_x, storefront_start.y - 55), Vector2(170, 90), COL_VAN, "Northstar van")
	var plate := EvidenceTarget.new()
	plate.evidence_id = "northstar_plate"
	plate.display_name = "van plate"
	plate.position = Vector2(van_x + 70, storefront_start.y - 30)
	add_child(plate)

	# One readable hazard: a curb set well into the flat row so it reads with
	# clear lead time after the descent. Ollie it; bonk at speed bails. Same low
	# 18 px height as Mercy Hill's curb so it's forgiving to clear.
	_box(Vector2(storefront_start.x + 850, storefront_start.y - 9),
			Vector2(46, 18), COL_OBSTACLE)

	# One branch: a high awning/rooftop one-way line over the safe street that
	# rejoins before the Spillway gate. Risk/style for "the line nobody sees."
	_segment(Vector2(storefront_start.x + 1050, storefront_start.y - 210),
			0.0, 520.0, COL_RISKY, "Awning line (risky)", true, 14.0)

	# Forward gate to the Spillway, plus a back gate to Mercy Hill for traversal.
	var spillway := SceneGate.new()
	spillway.target_scene = "res://scenes/routes/Spillway.tscn"
	spillway.label_text = "The Spillway"
	spillway.position = Vector2(p.x - 120, p.y - 24)
	add_child(spillway)

	var back := SceneGate.new()
	back.target_scene = "res://scenes/routes/MercyHill.tscn"
	back.label_text = "Back up the hill"
	back.position = Vector2(-220, -24)
	add_child(back)


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


func _grind_rail(start: Vector2, angle_deg: float, length: float, label := "") -> void:
	var rail: GrindRail = preload("res://scenes/rails/GrindRail.tscn").instantiate()
	rail.position = start
	rail.rotation = deg_to_rad(angle_deg)
	rail.end_point = Vector2(length, 0.0)
	rail.color = COL_RAIL
	if label != "":
		var l := Label.new()
		l.text = label
		l.position = Vector2(0.0, -40.0)
		l.modulate = Color(1, 1, 1, 0.45)
		rail.add_child(l)
	add_child(rail)


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


# --- HUD --------------------------------------------------------------------


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var title := Label.new()
	title.text = "MAIN STREET"
	title.position = Vector2(520, 14)
	layer.add_child(title)
	_objective = Label.new()
	_objective.position = Vector2(180, 40)
	_objective.modulate = Color(1.0, 0.85, 0.4)
	layer.add_child(_objective)

	var hint := Label.new()
	hint.text = "[W] push   [Space] ollie (hold = charge)   [S] brake/slide/grind   [C] camcorder   [E] record   [F] walk   [R] reset   [F3] debug"
	hint.position = Vector2(120, 690)
	hint.modulate = Color(1, 1, 1, 0.5)
	layer.add_child(hint)
