class_name Npc
extends Node2D
## Placeholder NPC: colored rectangle, name tag, talk prompt, one dialogue.
## Built in code by route scripts; final NPCs get sprites + schedules later.

const TALK_RANGE := 90.0

var npc_id := ""
var npc_name := ""
var color := Color.WHITE
var dialogue: Dictionary = {}

var _player: PlayerController
var _dbox: DialogueBox
var _prompt: Label
var _talking := false


func _ready() -> void:
	add_to_group("npc")
	var body := Polygon2D.new()
	body.color = color
	body.polygon = PackedVector2Array([
		Vector2(-11, -50), Vector2(11, -50), Vector2(11, 0), Vector2(-11, 0),
	])
	add_child(body)

	var nm := Label.new()
	nm.text = npc_name
	nm.position = Vector2(-30, -78)
	nm.modulate = Color(1, 1, 1, 0.8)
	add_child(nm)

	_prompt = Label.new()
	_prompt.text = "[E] talk"
	_prompt.position = Vector2(-26, -102)
	_prompt.modulate = Color(1.0, 1.0, 0.5)
	_prompt.visible = false
	add_child(_prompt)


func _process(_delta: float) -> void:
	if _player == null:
		_player = get_tree().get_first_node_in_group("player") as PlayerController
		_dbox = get_tree().get_first_node_in_group("dialogue_box") as DialogueBox
		if _player == null or _dbox == null:
			return

	var near := global_position.distance_to(_player.global_position) < TALK_RANGE
	_prompt.visible = near and not _talking and not _player.is_busy()
	if near and not _talking and not _player.is_busy() \
			and Input.is_action_just_pressed("interact"):
		_start_talk()


func _start_talk() -> void:
	_talking = true
	_player.begin_interaction()
	_dbox.finished.connect(_end_talk, CONNECT_ONE_SHOT)
	_dbox.start(dialogue)


func _end_talk() -> void:
	GameState.set_flag("talked_" + npc_id)
	_player.end_interaction()
	_talking = false
