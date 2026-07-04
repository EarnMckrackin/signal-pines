class_name ClimbZone
extends Area2D
## A climbable surface (chain link, ladder, drain pipe — design doc §14).
## While the player overlaps it, [W/Up] on foot (or mid on-foot jump) starts
## CLIMBING. Routes build these in code via make(); art is the route's job.

static func make(rect: Rect2) -> ClimbZone:
	var zone := ClimbZone.new()
	zone.position = rect.position + rect.size * 0.5
	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	zone.add_child(shape)
	return zone


func _ready() -> void:
	monitorable = false
	body_entered.connect(_on_body)
	body_exited.connect(_on_body_exit)


func _on_body(body: Node2D) -> void:
	if body is PlayerController:
		body.climbable_zones += 1


func _on_body_exit(body: Node2D) -> void:
	if body is PlayerController:
		body.climbable_zones = maxi(body.climbable_zones - 1, 0)
