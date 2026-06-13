class_name Atmosphere
extends Node2D
## Builds a route's environment from an AtmosphereConfig: a static sky gradient,
## parallax depth layers, ambient particles, a color grade, and foreground
## occluders. Drop one into a route and assign `config` (RoutePalettes builds
## them in code for now). Layers render an AI sprite when their texture is set,
## otherwise a procedural silhouette — so the look reads as deliberate before any
## generated art exists, and swapping art in later is just filling texture slots.
##
## Parallax2D follows the active Camera2D automatically (the player's
## CinematicCamera), so nothing here needs a camera reference.

@export var config: AtmosphereConfig

var _debug_label: Label
var _parallax: Array[Parallax2D] = []


func _ready() -> void:
	if config == null:
		push_warning("Atmosphere has no config; nothing built.")
		return
	_build_sky()
	_build_grade()
	for layer in config.layers:
		_build_layer(layer)
	for emitter in config.emitters:
		_build_emitter(emitter)
	for occ in config.occluders:
		_build_layer(occ)
	_build_debug()


func _process(_delta: float) -> void:
	if _debug_label == null:
		return
	if Input.is_action_just_pressed("atmosphere_toggle"):
		_debug_label.get_parent().visible = not _debug_label.get_parent().visible
	if _debug_label.get_parent().visible:
		var lines := PackedStringArray(["ATMOSPHERE: %s" % config.display_name])
		for p in _parallax:
			lines.append("%s  scroll=(%.2f,%.2f)  z=%d" % [
				p.name, p.scroll_scale.x, p.scroll_scale.y, p.z_index])
		lines.append("emitters: %d   fps: %d" % [
			config.emitters.size(), Engine.get_frames_per_second()])
		_debug_label.text = "\n".join(lines)


# --- Sky & grade ------------------------------------------------------------


func _build_sky() -> void:
	# Screen-fixed gradient behind everything; immune to camera zoom/pan.
	var grad := Gradient.new()
	grad.set_color(0, config.sky_top)
	grad.set_color(1, config.sky_bottom)
	var tex := GradientTexture2D.new()
	tex.gradient = grad
	tex.fill_from = Vector2(0, 0)
	tex.fill_to = Vector2(0, 1)
	tex.width = 8
	tex.height = 256

	var rect := TextureRect.new()
	rect.texture = tex
	rect.stretch_mode = TextureRect.STRETCH_SCALE
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)

	var sky := CanvasLayer.new()
	sky.layer = -100
	sky.name = "Sky"
	sky.add_child(rect)
	add_child(sky)


func _build_grade() -> void:
	if config.grade == Color.WHITE:
		return
	var grade := CanvasModulate.new()
	grade.color = config.grade
	add_child(grade)


# --- Layers -----------------------------------------------------------------


func _build_layer(layer: AtmosphereLayer) -> void:
	var content: Node2D
	if layer.texture != null:
		var spr := Sprite2D.new()
		spr.texture = layer.texture
		spr.centered = false
		spr.modulate = layer.tint
		content = spr
	elif layer.proc_kind != AtmosphereLayer.Kind.NONE:
		content = _proc_layer(layer)
	else:
		return

	var p := Parallax2D.new()
	p.name = AtmosphereLayer.Kind.keys()[layer.proc_kind] if layer.texture == null \
			else "TexLayer"
	p.scroll_scale = layer.scroll_scale
	if layer.repeat_size > 0.0:
		p.repeat_size = Vector2(layer.repeat_size, 0.0)
	p.position = layer.offset
	content.z_index = layer.z_index
	p.add_child(content)
	add_child(p)
	_parallax.append(p)


func _proc_layer(layer: AtmosphereLayer) -> Node2D:
	var rng := RandomNumberGenerator.new()
	rng.seed = layer.proc_seed
	match layer.proc_kind:
		AtmosphereLayer.Kind.SKY, AtmosphereLayer.Kind.HAZE:
			return _band(layer)
		AtmosphereLayer.Kind.HILLS:
			return _silhouette(layer, rng, 220.0, 600.0, 0.0)
		AtmosphereLayer.Kind.TREELINE:
			return _silhouette(layer, rng, 70.0, 110.0, 1.0)
		AtmosphereLayer.Kind.BUILDINGS:
			return _skyline(layer, rng)
		AtmosphereLayer.Kind.POLES:
			return _poles(layer, rng)
	return Node2D.new()


func _band(layer: AtmosphereLayer) -> Polygon2D:
	# A flat translucent strip (far haze / distant air).
	var poly := Polygon2D.new()
	poly.color = layer.proc_color
	var w := layer.proc_span
	var h := 160.0
	poly.polygon = PackedVector2Array([
		Vector2(-w * 0.5, layer.proc_base_y - h), Vector2(w * 0.5, layer.proc_base_y - h),
		Vector2(w * 0.5, layer.proc_base_y), Vector2(-w * 0.5, layer.proc_base_y)])
	return poly


func _silhouette(layer: AtmosphereLayer, rng: RandomNumberGenerator,
		min_h: float, max_h: float, jag: float) -> Polygon2D:
	# Rolling hills (jag=0, smoothed) or jagged treeline (jag=1). A filled
	# polygon spanning the route width, anchored at proc_base_y.
	var from_x := -layer.proc_span * 0.5
	var to_x := layer.proc_span * 0.5
	var base_y := layer.proc_base_y
	var pts := PackedVector2Array([Vector2(from_x, base_y)])
	var x := from_x
	var prev_h := rng.randf_range(min_h, max_h)
	while x < to_x:
		var step := rng.randf_range(60.0, 140.0)
		var h := rng.randf_range(min_h, max_h)
		if jag > 0.5:
			pts.append(Vector2(x + step * 0.5, base_y - h))
			pts.append(Vector2(x + step, base_y - rng.randf_range(min_h * 0.2, min_h * 0.5)))
		else:
			var mid := lerpf(prev_h, h, 0.5)
			pts.append(Vector2(x + step * 0.5, base_y - mid))
			pts.append(Vector2(x + step, base_y - h))
		prev_h = h
		x += step
	pts.append(Vector2(to_x, base_y))
	pts.append(Vector2(to_x, base_y + layer.proc_span))
	pts.append(Vector2(from_x, base_y + layer.proc_span))
	var poly := Polygon2D.new()
	poly.color = layer.proc_color
	poly.polygon = pts
	return poly


func _skyline(layer: AtmosphereLayer, rng: RandomNumberGenerator) -> Polygon2D:
	# A grounded rooftop silhouette: one filled polygon whose top edge steps up
	# over each building and down to the street between them, closed along a deep
	# baseline so there's solid mass below — no floating blocks.
	var from_x := -layer.proc_span * 0.5
	var to_x := layer.proc_span * 0.5
	var base_y := layer.proc_base_y
	var pts := PackedVector2Array([Vector2(from_x, base_y)])
	var x := from_x
	while x < to_x:
		var w := rng.randf_range(90.0, 190.0)
		var h := rng.randf_range(120.0, 320.0)
		var gap := rng.randf_range(8.0, 30.0)
		pts.append(Vector2(x, base_y - h))
		pts.append(Vector2(x + w, base_y - h))
		pts.append(Vector2(x + w, base_y))
		pts.append(Vector2(x + w + gap, base_y))
		x += w + gap
	pts.append(Vector2(to_x, base_y))
	pts.append(Vector2(to_x, base_y + layer.proc_span))
	pts.append(Vector2(from_x, base_y + layer.proc_span))
	var poly := Polygon2D.new()
	poly.color = layer.proc_color
	poly.polygon = pts
	return poly


func _poles(layer: AtmosphereLayer, rng: RandomNumberGenerator) -> Node2D:
	# Foreground telephone poles — sparse and dark, read as blurred near-camera
	# verticals the player passes behind. Bases sit well below frame (proc_base_y
	# is large) so only the tall upper shaft and crossarm sweep through view.
	var root := Node2D.new()
	var x := -layer.proc_span * 0.5
	var to_x := layer.proc_span * 0.5
	while x < to_x:
		var top := layer.proc_base_y - rng.randf_range(620.0, 760.0)
		var pole := Polygon2D.new()
		pole.color = layer.proc_color
		pole.polygon = PackedVector2Array([
			Vector2(x - 5, layer.proc_base_y), Vector2(x - 5, top),
			Vector2(x + 5, top), Vector2(x + 5, layer.proc_base_y)])
		root.add_child(pole)
		# Crossarm with two small insulator nubs, near the top.
		var arm_y := top + 46.0
		var arm := Polygon2D.new()
		arm.color = layer.proc_color
		arm.polygon = PackedVector2Array([
			Vector2(x - 30, arm_y), Vector2(x + 30, arm_y),
			Vector2(x + 30, arm_y + 9), Vector2(x - 30, arm_y + 9)])
		root.add_child(arm)
		for nub_x: float in [x - 22.0, x + 22.0]:
			var nub := Polygon2D.new()
			nub.color = layer.proc_color
			nub.polygon = PackedVector2Array([
				Vector2(nub_x - 3, arm_y), Vector2(nub_x + 3, arm_y),
				Vector2(nub_x + 3, arm_y - 10), Vector2(nub_x - 3, arm_y - 10)])
			root.add_child(nub)
		x += rng.randf_range(820.0, 1300.0)
	return root


# --- Particles --------------------------------------------------------------


func _build_emitter(e: AtmosphereEmitter) -> void:
	var p := CPUParticles2D.new()
	p.position = e.region_center
	p.amount = e.amount
	p.z_index = e.z_index
	p.local_coords = false
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = e.region_size * 0.5
	p.color = e.tint
	_configure_preset(p, e.preset)
	add_child(p)


func _configure_preset(p: CPUParticles2D, preset: int) -> void:
	match preset:
		AtmosphereEmitter.Preset.DUST:
			p.lifetime = 7.0
			p.gravity = Vector2(0, -4)
			p.initial_velocity_min = 2.0
			p.initial_velocity_max = 10.0
			p.scale_amount_min = 1.0
			p.scale_amount_max = 2.0
			p.angular_velocity_min = -20.0
			p.angular_velocity_max = 20.0
		AtmosphereEmitter.Preset.MIST:
			p.lifetime = 10.0
			p.gravity = Vector2.ZERO
			p.direction = Vector2(1, 0)
			p.spread = 10.0
			p.initial_velocity_min = 6.0
			p.initial_velocity_max = 16.0
			p.scale_amount_min = 8.0
			p.scale_amount_max = 18.0
		AtmosphereEmitter.Preset.EMBERS:
			p.lifetime = 4.0
			p.gravity = Vector2(0, -26)
			p.initial_velocity_min = 6.0
			p.initial_velocity_max = 22.0
			p.scale_amount_min = 1.0
			p.scale_amount_max = 2.5
			p.hue_variation_min = -0.05
			p.hue_variation_max = 0.05
		AtmosphereEmitter.Preset.RAIN:
			p.lifetime = 1.4
			p.gravity = Vector2(0, 1200)
			p.direction = Vector2(0.12, 1)
			p.spread = 2.0
			p.initial_velocity_min = 600.0
			p.initial_velocity_max = 800.0
			p.scale_amount_min = 1.0
			p.scale_amount_max = 1.0
		AtmosphereEmitter.Preset.LEAVES:
			p.lifetime = 6.0
			p.gravity = Vector2(0, 28)
			p.direction = Vector2(-0.5, 1)
			p.spread = 40.0
			p.initial_velocity_min = 14.0
			p.initial_velocity_max = 34.0
			p.angular_velocity_min = -120.0
			p.angular_velocity_max = 120.0
			p.scale_amount_min = 2.0
			p.scale_amount_max = 4.0


# --- Debug ------------------------------------------------------------------


func _build_debug() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 50
	layer.visible = false
	var panel := PanelContainer.new()
	panel.position = Vector2(980, 12)
	_debug_label = Label.new()
	_debug_label.add_theme_font_size_override("font_size", 12)
	panel.add_child(_debug_label)
	layer.add_child(panel)
	add_child(layer)
