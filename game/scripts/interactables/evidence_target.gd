class_name EvidenceTarget
extends Node2D
## Something the camcorder can capture. Dims once it's on tape.

var evidence_id := ""
var display_name := ""
var color := Color(0.95, 0.9, 0.55)


func _ready() -> void:
	add_to_group("evidence")
	var paper := Polygon2D.new()
	paper.color = color
	paper.polygon = PackedVector2Array([
		Vector2(-15, -20), Vector2(15, -20), Vector2(15, 20), Vector2(-15, 20),
	])
	add_child(paper)

	var nm := Label.new()
	nm.text = display_name
	nm.position = Vector2(-44, -48)
	nm.modulate = Color(1, 1, 1, 0.6)
	add_child(nm)


func _process(_delta: float) -> void:
	modulate.a = 0.45 if GameState.has_evidence(evidence_id) else 1.0
