class_name WaterZone
extends Area2D
## Standing water (spillway floor, tunnel puddles). While the player overlaps,
## wet_* tuning applies: heavy rolling drag, weaker kicks, slower walk/crawl.
## Routes build these in code via make() and draw their own water polygon.

static func make(rect: Rect2) -> WaterZone:
	var zone := WaterZone.new()
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
		body.water_zones += 1


func _on_body_exit(body: Node2D) -> void:
	if body is PlayerController:
		body.water_zones = maxi(body.water_zones - 1, 0)
