extends Node2D
## Mercy Hill graybox (Phase 2): a continuous safe ground line plus a risky
## one-way ledge + rail line floating above it. Geometry is built in code so
## the layout stays cheap to retune; final routes will move to TileMap/scenes.

const COL_GROUND := Color(0.32, 0.35, 0.4)
const COL_OBSTACLE := Color(0.55, 0.3, 0.3)
const COL_RISKY := Color(0.85, 0.65, 0.2)
const COL_RAIL := Color(1.0, 0.9, 0.25)
const COL_FINISH := Color(0.3, 0.9, 0.4, 0.35)

const START_LINE_X := 200.0

@onready var _player: PlayerController = $Player

var _run_started := false
var _run_finished := false
var _run_time := 0.0
var _hud_label: Label


func _ready() -> void:
	_build_route()
	_build_hud()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		_run_started = false
		_run_finished = false
		_run_time = 0.0
	if not _run_started and _player.global_position.x > START_LINE_X:
		_run_started = true
	if _run_started and not _run_finished:
		_run_time += delta
	_update_hud()


# --- Layout -----------------------------------------------------------------


func _build_route() -> void:
	# Safe line: one continuous floor from start to runout.
	var p := Vector2(-300, 0)
	p = _segment(p, 0.0, 900.0, COL_GROUND, "Start")
	p = _segment(p, 14.0, 1000.0, COL_GROUND, "Mercy Hill")
	p = _segment(p, 0.0, 730.0, COL_GROUND, "Flats")
	p = _segment(p, 18.0, 1400.0, COL_GROUND, "The Drop")
	p = _segment(p, 0.0, 1100.0, COL_GROUND, "Runout")

	# Curb on the Flats: ollie it, or bonk (bail at speed).
	_box(Vector2(2000, 233), Vector2(46, 18), COL_OBSTACLE)

	# Walls so the route has clean ends.
	_box(Vector2(-340, -150), Vector2(40, 300), COL_OBSTACLE)
	_box(Vector2(p.x + 20, p.y - 150), Vector2(40, 300), COL_OBSTACLE)

	# Risky/style line: a one-way ledge above the safe ground, then a grindable
	# rail. The rail has no collision — hold brake in the air near it to snap
	# on; missing it just drops you back to the safe line below.
	_segment(Vector2(1750, 150), 0.0, 400.0, COL_RISKY, "Ledge (risky)", true, 14.0)
	_grind_rail(Vector2(2350, 190), 18.0, 900.0, "Rail (hold S in air to grind)")

	_finish_area(Vector2(4450, 675))

	var gate := SceneGate.new()
	gate.target_scene = "res://scenes/routes/ZipsDiner.tscn"
	gate.label_text = "Zip's Diner"
	gate.position = Vector2(4300, 675)
	add_child(gate)

	# The Spillway opens once the crew at Zip's has set up the shoot.
	var spillway := SceneGate.new()
	spillway.target_scene = "res://scenes/routes/Spillway.tscn"
	spillway.label_text = "The Spillway"
	spillway.required_flag = "mission_zips_done"
	spillway.locked_text = "(find the crew at Zip's first)"
	spillway.position = Vector2(4120, 675)
	add_child(spillway)


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

	body.add_child(_rect_poly(length, thickness, color))

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
	body.add_child(_rect_poly(size.x, size.y, color))
	add_child(body)


func _rect_poly(width: float, height: float, color: Color) -> Polygon2D:
	var poly := Polygon2D.new()
	poly.color = color
	var hw := width * 0.5
	var hh := height * 0.5
	poly.polygon = PackedVector2Array([
		Vector2(-hw, -hh), Vector2(hw, -hh), Vector2(hw, hh), Vector2(-hw, hh),
	])
	return poly


func _finish_area(pos: Vector2) -> void:
	var area := Area2D.new()
	area.position = pos + Vector2(0, -100)
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(60, 200)
	shape.shape = rect
	area.add_child(shape)
	area.add_child(_rect_poly(60, 200, COL_FINISH))
	area.body_entered.connect(_on_finish_entered)
	add_child(area)


func _on_finish_entered(body: Node2D) -> void:
	if body == _player and _run_started and not _run_finished:
		_run_finished = true


# --- HUD --------------------------------------------------------------------


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	_hud_label = Label.new()
	_hud_label.position = Vector2(440, 14)
	_hud_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layer.add_child(_hud_label)

	var hint := Label.new()
	hint.text = "[W] tap to push   [Space] ollie (hold = charge)   [S] brake/slide/grind   [F] walk or ride   [R] reset   [F3] debug"
	hint.position = Vector2(180, 690)
	hint.modulate = Color(1, 1, 1, 0.5)
	layer.add_child(hint)


func _update_hud() -> void:
	if _run_finished:
		_hud_label.text = "FINISH — %.2f s\npress R to run it again" % _run_time
	elif _run_started:
		_hud_label.text = "%.2f s" % _run_time
	else:
		_hud_label.text = "MERCY HILL\nbomb the hill"
