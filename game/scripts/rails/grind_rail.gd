class_name GrindRail
extends Node2D
## A grindable rail: a straight path from this node's origin to end_point
## (local space). The player finds rails through the "grind_rails" group and
## queries the path helpers below; the rail itself has no collision, so a
## missed grind drops the player to whatever is underneath.
## Extension point: curved rails would swap the two-point math for a Curve2D
## while keeping the same offset/point/direction interface.

const GROUP := "grind_rails"

@export var end_point := Vector2(200.0, 0.0):
	set(value):
		end_point = value
		queue_redraw()
@export var color := Color(1.0, 0.9, 0.25)
@export var thickness := 6.0

# Set by the debug overlay; the rail only stores and draws them.
var debug_draw := false:
	set(value):
		debug_draw = value
		queue_redraw()
var debug_snap_radius := 0.0
var debug_active := false:
	set(value):
		if value != debug_active:
			debug_active = value
			queue_redraw()


func _ready() -> void:
	add_to_group(GROUP)


func length() -> float:
	return (global_end() - global_start()).length()


func direction() -> Vector2:
	## Unit vector from start to end, in global space.
	return (global_end() - global_start()).normalized()


func global_start() -> Vector2:
	return global_position


func global_end() -> Vector2:
	return to_global(end_point)


func closest_offset(point: Vector2) -> float:
	## Distance along the rail (0..length) of the rail point nearest to `point`.
	return clampf((point - global_start()).dot(direction()), 0.0, length())


func global_point_at(offset: float) -> Vector2:
	return global_start() + direction() * clampf(offset, 0.0, length())


func distance_to(point: Vector2) -> float:
	return (global_point_at(closest_offset(point)) - point).length()


func _draw() -> void:
	draw_line(Vector2.ZERO, end_point, color, thickness)
	if not debug_draw:
		return
	# Snap radius as a translucent band around the rail line.
	var band := Color(0.4, 1.0, 0.6, 0.35) if debug_active else Color(1.0, 1.0, 1.0, 0.18)
	if debug_snap_radius > 0.0:
		draw_line(Vector2.ZERO, end_point, band, debug_snap_radius * 2.0)
		draw_circle(Vector2.ZERO, debug_snap_radius, band)
		draw_circle(end_point, debug_snap_radius, band)
