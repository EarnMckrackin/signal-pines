class_name RoutePalettes
extends RefCounted
## Code-built AtmosphereConfigs, one per route — the art-direction palettes live
## here for now (saveable to .tres later). Each returns a fresh config so a route
## can tweak it before handing it to its Atmosphere node. Procedural silhouettes
## fill in until AI sprites are dropped into the layer texture slots.
##
## proc_base_y is in the route's world space (y grows downward); routes sit
## around y=0 at the start and descend, so silhouettes anchor a bit below 0 and
## hang downward behind the geometry.


static func _layer(kind: AtmosphereLayer.Kind, scroll: float, z: int,
		color: Color, base_y: float, span := 9000.0, seed_ := 0,
		alt := Color.TRANSPARENT) -> AtmosphereLayer:
	var l := AtmosphereLayer.new()
	l.proc_kind = kind
	l.scroll_scale = Vector2(scroll, scroll)
	l.z_index = z
	l.proc_color = color
	l.proc_color_alt = alt if alt.a > 0.0 else color.lightened(0.12)
	l.proc_base_y = base_y
	l.proc_span = span
	l.proc_seed = seed_
	return l


static func _emitter(preset: AtmosphereEmitter.Preset, center: Vector2,
		size: Vector2, amount: int, tint: Color, z := 6) -> AtmosphereEmitter:
	var e := AtmosphereEmitter.new()
	e.preset = preset
	e.region_center = center
	e.region_size = size
	e.amount = amount
	e.tint = tint
	e.z_index = z
	return e


static func mercy_hill() -> AtmosphereConfig:
	# Overcast PNW afternoon, drizzle coming down the ridge: layered evergreen
	# silhouettes, a haze band between them, mist pooling near the road, light
	# rain, and a film-grain finish. Muted, damp, 1986.
	var c := AtmosphereConfig.new()
	c.display_name = "Mercy Hill — overcast drizzle"
	c.sky_top = Color(0.42, 0.5, 0.58)
	c.sky_bottom = Color(0.68, 0.7, 0.67)
	c.grade = Color(0.93, 0.96, 0.97)
	c.layers = [
		_layer(AtmosphereLayer.Kind.HILLS, 0.12, -32, Color(0.44, 0.52, 0.56), -140.0, 11000.0, 11),
		_layer(AtmosphereLayer.Kind.TREELINE, 0.3, -26, Color(0.26, 0.35, 0.34), -50.0, 11000.0, 12),
		_layer(AtmosphereLayer.Kind.HAZE, 0.42, -22, Color(0.62, 0.67, 0.68, 0.35), 60.0, 11000.0),
		_layer(AtmosphereLayer.Kind.TREELINE, 0.55, -18, Color(0.12, 0.19, 0.17), 40.0, 11000.0, 13),
	]
	c.emitters = [
		_emitter(AtmosphereEmitter.Preset.RAIN, Vector2(2200, -400),
				Vector2(5600, 200), 70, Color(0.75, 0.8, 0.86, 0.2), 7),
		_emitter(AtmosphereEmitter.Preset.MIST, Vector2(2200, 340),
				Vector2(5200, 140), 16, Color(0.72, 0.76, 0.78, 0.08), 7),
		_emitter(AtmosphereEmitter.Preset.DUST, Vector2(2200, 200),
				Vector2(5200, 700), 30, Color(0.9, 0.92, 0.88, 0.2)),
	]
	c.occluders = [
		_layer(AtmosphereLayer.Kind.POLES, 1.25, 8, Color(0.07, 0.08, 0.09), 360.0, 11000.0, 14),
	]
	c.grain = 0.055
	c.vignette = 0.3
	return c


static func main_street() -> AtmosphereConfig:
	# Early dusk: the evening starts to come down. Distant rooftops, ridgeline,
	# drifting leaves, streetlight haze.
	var c := AtmosphereConfig.new()
	c.display_name = "Main Street — early dusk"
	c.sky_top = Color(0.16, 0.16, 0.26)
	c.sky_bottom = Color(0.5, 0.34, 0.32)
	c.grade = Color(0.92, 0.86, 0.9)
	c.layers = [
		_layer(AtmosphereLayer.Kind.TREELINE, 0.18, -30, Color(0.16, 0.17, 0.26), -40.0, 11000.0, 21),
		_layer(AtmosphereLayer.Kind.BUILDINGS, 0.4, -24, Color(0.12, 0.12, 0.18), 320.0, 11000.0, 22,
				Color(0.16, 0.15, 0.22)),
		_layer(AtmosphereLayer.Kind.HAZE, 0.6, -16, Color(0.5, 0.35, 0.4, 0.16), 160.0, 11000.0, 23),
	]
	c.emitters = [
		_emitter(AtmosphereEmitter.Preset.LEAVES, Vector2(2400, 60),
				Vector2(5400, 500), 26, Color(0.7, 0.5, 0.3, 0.7)),
		_emitter(AtmosphereEmitter.Preset.DUST, Vector2(2400, 120),
				Vector2(5400, 600), 30, Color(0.9, 0.7, 0.6, 0.22)),
	]
	c.occluders = [
		_layer(AtmosphereLayer.Kind.POLES, 1.3, 8, Color(0.05, 0.05, 0.07), 600.0, 11000.0, 24),
	]
	return c


static func spillway() -> AtmosphereConfig:
	# Full dusk at the canal: deep sky, ember horizon, black treeline, mist on the
	# floor, embers in the air. The Mouth arch stays in the scene (mission art).
	var c := AtmosphereConfig.new()
	c.display_name = "The Spillway — dusk"
	c.sky_top = Color(0.07, 0.07, 0.15)
	c.sky_bottom = Color(0.36, 0.16, 0.12)
	c.grade = Color(0.84, 0.84, 1.0)
	c.layers = [
		_layer(AtmosphereLayer.Kind.TREELINE, 0.2, -30, Color(0.05, 0.07, 0.07), -120.0, 11000.0, 31),
		_layer(AtmosphereLayer.Kind.TREELINE, 0.4, -22, Color(0.03, 0.045, 0.05), -40.0, 11000.0, 32),
	]
	c.emitters = [
		_emitter(AtmosphereEmitter.Preset.MIST, Vector2(1900, 300),
				Vector2(3600, 120), 22, Color(0.55, 0.6, 0.78, 0.1), 8),
		_emitter(AtmosphereEmitter.Preset.EMBERS, Vector2(2400, 220),
				Vector2(3200, 500), 28, Color(0.9, 0.5, 0.2, 0.5)),
	]
	return c
