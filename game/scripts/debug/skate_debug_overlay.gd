extends CanvasLayer
## Dev-only readout for movement tuning. Toggle with F3.
## While visible, rails draw their snap band; the active/nearest one is lit.

@onready var _label: Label = $Panel/Label

var _player: PlayerController
var _lit_rail: GrindRail


func _ready() -> void:
	_player = owner as PlayerController


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_toggle"):
		visible = not visible
		_set_rail_debug(visible)
	if not visible or _player == null:
		return
	var charge_pct := 0.0
	if _player.tuning.crouch_charge_time > 0.0:
		charge_pct = 100.0 * _player.crouch_charge / _player.tuning.crouch_charge_time
	_label.text = "state: %s\nspeed: %.0f\nvel: (%.0f, %.0f)\ngrounded: %s\nslope: %s\nlean: %.1f\nfacing: %d\ncharge: %.0f%%\nlanding: %s\nbail: %s\ngrind: %s\nflags: %s\nevidence: %s\nfps: %d" % [
		SkateState.NAMES.get(_player.state, "?"),
		_player.velocity.length(),
		_player.velocity.x, _player.velocity.y,
		_player.is_on_floor(),
		_slope_text(),
		Input.get_axis("lean_left", "lean_right"),
		_player.facing,
		charge_pct,
		_landing_text(),
		_player.last_bail_reason if _player.last_bail_reason != "" else "-",
		_grind_text(),
		", ".join(GameState.flags.keys()) if not GameState.flags.is_empty() else "-",
		", ".join(GameState.evidence) if not GameState.evidence.is_empty() else "-",
		Engine.get_frames_per_second(),
	]
	_highlight_rail(_grind_target())


func _slope_text() -> String:
	if not _player.is_on_floor():
		return "-"
	return "%.0f°" % rad_to_deg(_player.get_floor_normal().angle_to(Vector2.UP))


func _landing_text() -> String:
	if _player.last_landing_speed_in <= 0.0:
		return "-"
	return "%.0f → %.0f (%.0f%% kept)" % [
		_player.last_landing_speed_in,
		_player.last_landing_speed_out,
		100.0 * _player.last_landing_speed_out / _player.last_landing_speed_in,
	]


func _grind_target() -> GrindRail:
	if _player.grind_rail != null:
		return _player.grind_rail
	if _player.state == SkateState.AIRBORNE:
		return _player.nearest_rail
	return null


func _grind_text() -> String:
	if _player.grind_rail != null:
		return "ON %s" % _player.grind_rail.name
	if _player.state == SkateState.AIRBORNE and _player.nearest_rail != null:
		var in_range := _player.nearest_rail_distance <= _player.tuning.grind_snap_distance
		return "%s d=%.0f%s" % [_player.nearest_rail.name,
				_player.nearest_rail_distance, " (in range)" if in_range else ""]
	return "-"


func _set_rail_debug(on: bool) -> void:
	for rail: GrindRail in get_tree().get_nodes_in_group(GrindRail.GROUP):
		rail.debug_snap_radius = _player.tuning.grind_snap_distance if _player else 0.0
		rail.debug_draw = on
	if not on:
		_highlight_rail(null)


func _highlight_rail(rail: GrindRail) -> void:
	if rail == _lit_rail:
		return
	if _lit_rail != null and is_instance_valid(_lit_rail):
		_lit_rail.debug_active = false
	_lit_rail = rail
	if _lit_rail != null:
		_lit_rail.debug_active = true
