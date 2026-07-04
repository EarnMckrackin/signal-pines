extends Node2D
## Tunnel Traversal Toy (Phase 7). Isolated mechanic playground per the
## iteration framework: prove crawl, standing water, climbable surfaces, and
## the wedged door feel right on foot BEFORE any of it enters the Spillway
## tunnel.
##
## Art direction: claustrophobic wet brick interior. Vines creep through
## cracks, utility pipes line the ceiling, graffiti marks the walls, water
## pools on the floor. Ceiling and walls enclose the course. Heavy grain +
## vignette. No sky visible.
##
## Course, left to right:
##   1. low duct   — hold [S] to crawl under (headroom holds the crawl)
##   2. water pool — wet drag on the walk
##   3. ladder     — [W] to grab + climb, lean to drift, [Space] hops off
##   4. wedged door — hold [E] to shove it open
##   5. exit pad   — completion + time

# --- Palette ----------------------------------------------------------------
# Old brick, wet concrete, corroded metal. Everything dark, warm undertone.
const COL_BRICK      := Color(0.2, 0.13, 0.1)
const COL_BRICK_ALT  := Color(0.24, 0.15, 0.11)
const COL_MORTAR     := Color(0.14, 0.1, 0.08)
const COL_FLOOR      := Color(0.16, 0.15, 0.14)
const COL_CEILING    := Color(0.1, 0.1, 0.1)
const COL_DUCT       := Color(0.12, 0.11, 0.1)
const COL_WATER      := Color(0.06, 0.1, 0.18, 0.7)
const COL_WATER_SURF := Color(0.15, 0.22, 0.32, 0.45)
const COL_LADDER     := Color(0.36, 0.32, 0.28)
const COL_LADDER_RIM := Color(0.48, 0.44, 0.38)
const COL_DOOR       := Color(0.3, 0.24, 0.18)
const COL_PIPE       := Color(0.22, 0.24, 0.2)
const COL_EXIT       := Color(0.3, 0.9, 0.4, 0.25)
const COL_GRAFFITI   := [
	Color(0.7, 0.25, 0.2, 0.6),   # faded red
	Color(0.2, 0.5, 0.7, 0.45),   # blue
	Color(0.85, 0.75, 0.2, 0.4),  # yellow
	Color(0.9, 0.9, 0.9, 0.35),   # white
]

const COURSE_TOP    := -380.0     # ceiling top (collision + art)
const COURSE_BOTTOM := 0.0        # floor top
const GALLERY_Y     := -240.0     # upper ledge floor

const DOOR_X := 2260.0
const DOOR_WEDGE_TIME := 1.4
const EXIT_X := 2620.0

@onready var _player: PlayerController = $Player

var _time := 0.0
var _finished := false
var _door_progress := 0.0
var _door_open := false
var _door_body: StaticBody2D
var _door_poly: Polygon2D
var _hud: Label
var _door_label: Label
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.seed = 1986
	_build_atmosphere()
	_build_enclosure()
	_build_course()
	_build_dressing()
	_build_hud()
	_player.set_on_foot()


func _process(delta: float) -> void:
	if not _finished:
		_time += delta
	if Input.is_action_just_pressed("reset"):
		_time = 0.0
		_finished = false
		_player.set_on_foot.call_deferred()
	_process_door(delta)
	if not _finished and _player.global_position.x > EXIT_X:
		_finished = true
	_hud.text = "TUNNEL TOY   %s   %.1fs" % [
		"COMPLETE — [R] to rerun" if _finished else "crawl / wade / climb / shove",
		_time]


func _process_door(delta: float) -> void:
	if _door_open:
		return
	var near := absf(_player.global_position.x - DOOR_X) < 80.0 \
			and _player.global_position.y < -160.0
	if near and Input.is_action_pressed("interact") and not _player.is_busy():
		_door_progress = minf(_door_progress + delta, DOOR_WEDGE_TIME)
		if _door_progress >= DOOR_WEDGE_TIME:
			_open_door()
	elif _door_progress > 0.0:
		_door_progress = maxf(_door_progress - delta * 0.5, 0.0)
	_door_label.visible = near and not _door_open
	_door_label.text = "[hold E] shove  %d%%" % roundi(100.0 * _door_progress / DOOR_WEDGE_TIME)


func _open_door() -> void:
	_door_open = true
	GameState.set_flag("tunnel_door_wedged")
	var tw := create_tween()
	tw.tween_property(_door_poly, "position:y", -130.0, 0.5) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_door_body.get_node("Col").set_deferred("disabled", true)


func _build_atmosphere() -> void:
	var atmo := Atmosphere.new()
	atmo.config = RoutePalettes.tunnel()
	add_child(atmo)


# --- Enclosure (ceiling + walls = no outside visible) -----------------------


func _build_enclosure() -> void:
	# Ceiling: continuous slab the full course length.
	_box(Vector2(-360, COURSE_TOP - 200), Vector2(3400, 200), COL_CEILING)
	# Left wall.
	_box(Vector2(-360, COURSE_TOP), Vector2(60, COURSE_BOTTOM - COURSE_TOP + 60), COL_BRICK)
	# Right wall (past exit).
	_box(Vector2(2900, COURSE_TOP), Vector2(60, COURSE_BOTTOM - COURSE_TOP + 60), COL_BRICK)
	# Back wall fill: a huge dark rectangle behind everything.
	var bw := Polygon2D.new()
	bw.color = COL_MORTAR
	bw.polygon = PackedVector2Array([
		Vector2(-360, COURSE_TOP), Vector2(2960, COURSE_TOP),
		Vector2(2960, COURSE_BOTTOM + 60), Vector2(-360, COURSE_BOTTOM + 60)])
	bw.z_index = -35
	add_child(bw)


# --- Course (functional geometry) -------------------------------------------


func _build_course() -> void:
	# Lower floor.
	_box(Vector2(-300, COURSE_BOTTOM), Vector2(1980, 60), COL_FLOOR)

	# 1. Low duct: slab leaving a 34 px gap.
	_box(Vector2(420, COURSE_TOP), Vector2(400, COURSE_TOP * -1 - 34), COL_DUCT)
	_label(Vector2(300, -80), "[hold S] crawl")

	# 2. Water pool.
	add_child(WaterZone.make(Rect2(980, -60, 400, 60)))
	var water := Polygon2D.new()
	water.color = COL_WATER
	water.polygon = PackedVector2Array([
		Vector2(980, -16), Vector2(1380, -16), Vector2(1380, 0), Vector2(980, 0)])
	water.z_index = 6
	add_child(water)
	# Surface sheen.
	var sheen := Polygon2D.new()
	sheen.color = COL_WATER_SURF
	sheen.polygon = PackedVector2Array([
		Vector2(980, -18), Vector2(1380, -18), Vector2(1380, -16), Vector2(980, -16)])
	sheen.z_index = 7
	add_child(sheen)
	_label(Vector2(1080, -80), "standing water")

	# 3. Gallery wall + ladder.
	_box(Vector2(1680, GALLERY_Y), Vector2(1220, COURSE_BOTTOM - GALLERY_Y + 60), COL_BRICK_ALT)
	# Gallery ceiling (enclosed room above).
	_box(Vector2(1680, COURSE_TOP), Vector2(1220, COURSE_TOP * -1 + GALLERY_Y), COL_CEILING)
	add_child(ClimbZone.make(Rect2(1652, GALLERY_Y - 22, 32, COURSE_BOTTOM - GALLERY_Y + 22)))
	_ladder_rungs(1652.0, GALLERY_Y - 18.0, COURSE_BOTTOM)
	_label(Vector2(1520, GALLERY_Y - 60), "[W] climb")

	# 4. Wedged door on the gallery.
	_door_body = StaticBody2D.new()
	_door_body.position = Vector2(DOOR_X, 0)
	var col := CollisionShape2D.new()
	col.name = "Col"
	var shape := RectangleShape2D.new()
	shape.size = Vector2(36, 120)
	col.shape = shape
	col.position = Vector2(0, -300)
	_door_body.add_child(col)
	_door_poly = Polygon2D.new()
	_door_poly.color = COL_DOOR
	_door_poly.polygon = PackedVector2Array([
		Vector2(-18, -360), Vector2(18, -360), Vector2(18, -240), Vector2(-18, -240)])
	_door_body.add_child(_door_poly)
	add_child(_door_body)

	# 5. Exit pad.
	var exit_pad := Polygon2D.new()
	exit_pad.color = COL_EXIT
	exit_pad.polygon = PackedVector2Array([
		Vector2(EXIT_X, -360), Vector2(EXIT_X + 120, -360),
		Vector2(EXIT_X + 120, -240), Vector2(EXIT_X, -240)])
	add_child(exit_pad)
	_label(Vector2(EXIT_X, COURSE_TOP - 10), "EXIT")


# --- Dressing (non-functional visual detail) --------------------------------


func _build_dressing() -> void:
	_build_wall_bricks()
	_build_graffiti()
	_build_ceiling_pipes()
	_build_puddle_stains()


func _build_wall_bricks() -> void:
	# Visible brick courses on the lower-level walls (above and below the duct
	# slab, on the gallery face). Mortar-line horizontal strips.
	for wall_rect: Array in [
		[Vector2(-300, COURSE_TOP), Vector2(720, COURSE_TOP * -1)],
		[Vector2(820, COURSE_TOP), Vector2(860, COURSE_TOP * -1)],
	]:
		var pos: Vector2 = wall_rect[0]
		var size: Vector2 = wall_rect[1]
		_brick_overlay(pos, size, -32)


func _brick_overlay(pos: Vector2, size: Vector2, z: int) -> void:
	var root := Node2D.new()
	root.z_index = z
	var row_h := 14.0
	var mortar_h := 2.0
	var y := pos.y + size.y
	var row := 0
	while y > pos.y:
		var mortar := Polygon2D.new()
		mortar.color = COL_MORTAR
		mortar.polygon = PackedVector2Array([
			Vector2(pos.x, y - mortar_h), Vector2(pos.x + size.x, y - mortar_h),
			Vector2(pos.x + size.x, y), Vector2(pos.x, y)])
		root.add_child(mortar)
		# Vertical mortar joints every ~32 px, offset per row.
		var jx := pos.x + (16.0 if row % 2 == 1 else 0.0)
		while jx < pos.x + size.x:
			var joint := Polygon2D.new()
			joint.color = COL_MORTAR
			joint.polygon = PackedVector2Array([
				Vector2(jx, y - row_h), Vector2(jx + 2, y - row_h),
				Vector2(jx + 2, y - mortar_h), Vector2(jx, y - mortar_h)])
			root.add_child(joint)
			jx += 32.0
		y -= row_h
		row += 1
	add_child(root)


func _build_graffiti() -> void:
	# Crude spray marks: small rectangles and diagonal slashes in faded colors.
	# Placed on open wall sections where the player can see them.
	var tags := [
		Vector2(80, -180), Vector2(160, -280), Vector2(920, -140),
		Vector2(1300, -320), Vector2(1900, -310), Vector2(2400, -300),
	]
	for pos: Vector2 in tags:
		_spray_tag(pos)


func _spray_tag(pos: Vector2) -> void:
	var root := Node2D.new()
	root.z_index = -30
	var col: Color = COL_GRAFFITI[_rng.randi_range(0, COL_GRAFFITI.size() - 1)]
	# 2–4 strokes per tag.
	for i in range(_rng.randi_range(2, 4)):
		var stroke := Polygon2D.new()
		stroke.color = col
		var sx := pos.x + _rng.randf_range(-20, 20)
		var sy := pos.y + _rng.randf_range(-14, 14)
		var sw := _rng.randf_range(12, 40)
		var sh := _rng.randf_range(3, 8)
		var skew := _rng.randf_range(-6, 6)
		stroke.polygon = PackedVector2Array([
			Vector2(sx, sy), Vector2(sx + sw, sy + skew),
			Vector2(sx + sw, sy + skew + sh), Vector2(sx, sy + sh)])
		root.add_child(stroke)
	add_child(root)


func _build_ceiling_pipes() -> void:
	# Foreground pipe runs across the ceiling of the lower level.
	var root := Node2D.new()
	root.z_index = 5
	for pipe_y: float in [COURSE_TOP + 30, COURSE_TOP + 52]:
		var pipe := Polygon2D.new()
		pipe.color = COL_PIPE
		pipe.polygon = PackedVector2Array([
			Vector2(-300, pipe_y), Vector2(1650, pipe_y),
			Vector2(1650, pipe_y + 7), Vector2(-300, pipe_y + 7)])
		root.add_child(pipe)
		# Highlight.
		var rim := Polygon2D.new()
		rim.color = COL_PIPE.lightened(0.2)
		rim.polygon = PackedVector2Array([
			Vector2(-300, pipe_y), Vector2(1650, pipe_y),
			Vector2(1650, pipe_y + 2), Vector2(-300, pipe_y + 2)])
		root.add_child(rim)
	add_child(root)


func _build_puddle_stains() -> void:
	# Dark wet stains near the water pool to sell the dampness.
	var root := Node2D.new()
	root.z_index = -33
	for sx: float in [900.0, 960.0, 1390.0, 1440.0]:
		var stain := Polygon2D.new()
		stain.color = Color(0.08, 0.08, 0.1, 0.3)
		var sw := _rng.randf_range(30, 70)
		stain.polygon = PackedVector2Array([
			Vector2(sx, -4), Vector2(sx + sw, -4),
			Vector2(sx + sw, 0), Vector2(sx, 0)])
		root.add_child(stain)
	add_child(root)


# --- Shared builders --------------------------------------------------------


func _ladder_rungs(x: float, top: float, bottom: float) -> void:
	var art := Node2D.new()
	for rail_x: float in [x + 4.0, x + 26.0]:
		var rail := Polygon2D.new()
		rail.color = COL_LADDER
		rail.polygon = PackedVector2Array([
			Vector2(rail_x - 2, top), Vector2(rail_x + 2, top),
			Vector2(rail_x + 2, bottom), Vector2(rail_x - 2, bottom)])
		art.add_child(rail)
		# Rim highlight on left edge.
		var rim := Polygon2D.new()
		rim.color = COL_LADDER_RIM
		rim.polygon = PackedVector2Array([
			Vector2(rail_x - 2, top), Vector2(rail_x - 1, top),
			Vector2(rail_x - 1, bottom), Vector2(rail_x - 2, bottom)])
		art.add_child(rim)
	var y := top + 14.0
	while y < bottom - 6.0:
		var rung := Polygon2D.new()
		rung.color = COL_LADDER
		rung.polygon = PackedVector2Array([
			Vector2(x + 2, y), Vector2(x + 28, y),
			Vector2(x + 28, y + 4), Vector2(x + 2, y + 4)])
		art.add_child(rung)
		y += 26.0
	add_child(art)


func _box(pos: Vector2, size: Vector2, color: Color) -> void:
	var body := StaticBody2D.new()
	body.position = pos + size * 0.5
	var col := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = size
	col.shape = shape
	body.add_child(col)
	var poly := Polygon2D.new()
	poly.color = color
	poly.polygon = PackedVector2Array([
		-size * 0.5, Vector2(size.x, -size.y) * 0.5,
		size * 0.5, Vector2(-size.x, size.y) * 0.5])
	body.add_child(poly)
	add_child(body)


func _label(pos: Vector2, text: String) -> void:
	var l := Label.new()
	l.text = text
	l.position = pos
	l.modulate = Color(1, 1, 1, 0.55)
	add_child(l)


func _build_hud() -> void:
	var layer := CanvasLayer.new()
	_hud = Label.new()
	_hud.position = Vector2(12, 690)
	layer.add_child(_hud)
	_door_label = Label.new()
	_door_label.position = Vector2(560, 200)
	_door_label.modulate = Color(1, 1, 0.5)
	_door_label.visible = false
	layer.add_child(_door_label)
	add_child(layer)
