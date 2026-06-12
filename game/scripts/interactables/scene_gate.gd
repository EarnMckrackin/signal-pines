class_name SceneGate
extends Node2D
## Walk-up door between scenes: shows a prompt in range, loads target on [E].

const USE_RANGE := 90.0

var target_scene := ""
var label_text := "Enter"

var _player: PlayerController
var _prompt: Label


func _ready() -> void:
	var door := Polygon2D.new()
	door.color = Color(0.2, 0.22, 0.3)
	door.polygon = PackedVector2Array([
		Vector2(-26, -110), Vector2(26, -110), Vector2(26, 0), Vector2(-26, 0),
	])
	add_child(door)

	var nm := Label.new()
	nm.text = label_text
	nm.position = Vector2(-40, -140)
	nm.modulate = Color(1, 1, 1, 0.8)
	add_child(nm)

	_prompt = Label.new()
	_prompt.text = "[E] enter"
	_prompt.position = Vector2(-32, -164)
	_prompt.modulate = Color(1.0, 1.0, 0.5)
	_prompt.visible = false
	add_child(_prompt)


func _process(_delta: float) -> void:
	if _player == null:
		_player = get_tree().get_first_node_in_group("player") as PlayerController
		if _player == null:
			return
	var near := global_position.distance_to(_player.global_position) < USE_RANGE
	_prompt.visible = near and not _player.is_busy()
	if near and not _player.is_busy() and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file(target_scene)
