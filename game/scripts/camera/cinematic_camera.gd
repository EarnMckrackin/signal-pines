class_name CinematicCamera
extends Camera2D
## Follow camera: leads the player in their direction of travel and eases the
## zoom out as speed builds, so fast lines read without fighting the player.
## Phase 2+ extension point: camera zones can tween limits/zoom per route section.

@export var lookahead_time := 0.25
@export var lookahead_smoothing := 3.0
@export var vertical_lead := 0.08
@export var min_zoom := 0.72
@export var zoom_speed_ref := 900.0

var _target: CharacterBody2D


func _ready() -> void:
	_target = owner as CharacterBody2D
	position_smoothing_enabled = true
	position_smoothing_speed = 6.0


func _process(delta: float) -> void:
	if _target == null:
		return
	var v := _target.velocity
	var want := Vector2(
		v.x * lookahead_time,
		clampf(v.y * vertical_lead, -40.0, 90.0)
	)
	offset = offset.lerp(want, 1.0 - exp(-lookahead_smoothing * delta))

	var speed_t := clampf(v.length() / zoom_speed_ref, 0.0, 1.0)
	var z := lerpf(1.0, min_zoom, speed_t)
	zoom = zoom.lerp(Vector2(z, z), 1.0 - exp(-2.0 * delta))
