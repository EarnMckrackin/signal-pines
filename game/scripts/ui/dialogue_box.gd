class_name DialogueBox
extends CanvasLayer
## Minimal data-driven dialogue UI (Phase 4). Not a dialogue engine: data is
## a Dictionary of named sections, each an Array of entries:
##   {"speaker": "Eli", "text": "...", "set_flag": optional}   - one page
##   {"choice": [{"text": "...", "goto": "section", "set_flag": opt}, ...]}
##   {"goto": "section"}                                       - jump
## Flow starts at "start"; running off the end of a section closes the box.

signal finished

var _sections: Dictionary = {}
var _section: Array = []
var _index := 0
var _in_choice := false
var _choice_index := 0
var _skip_frame := false

var _name_label: Label
var _text_label: Label
var _choices_box: VBoxContainer
var _hint: Label


func _ready() -> void:
	layer = 50
	add_to_group("dialogue_box")
	visible = false

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	panel.offset_left = 160.0
	panel.offset_right = -160.0
	panel.offset_top = -200.0
	panel.offset_bottom = -36.0
	add_child(panel)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	panel.add_child(v)

	_name_label = Label.new()
	_name_label.modulate = Color(1.0, 0.8, 0.35)
	v.add_child(_name_label)

	_text_label = Label.new()
	_text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_text_label.custom_minimum_size = Vector2(0, 60)
	v.add_child(_text_label)

	_choices_box = VBoxContainer.new()
	v.add_child(_choices_box)

	_hint = Label.new()
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_hint.modulate = Color(1, 1, 1, 0.4)
	v.add_child(_hint)


func start(dialogue: Dictionary) -> void:
	_sections = dialogue
	visible = true
	# The interact press that opened the box must not also advance page one.
	_skip_frame = true
	_enter_section("start")


func _process(_delta: float) -> void:
	if not visible:
		return
	if _skip_frame:
		_skip_frame = false
		return

	if _in_choice:
		var move := 0
		if Input.is_action_just_pressed("brake"):
			move = 1
		elif Input.is_action_just_pressed("push"):
			move = -1
		if move != 0:
			var count := (_section[_index]["choice"] as Array).size()
			_choice_index = clampi(_choice_index + move, 0, count - 1)
			_refresh_choices()
		if Input.is_action_just_pressed("interact"):
			_pick(_choice_index)
	elif Input.is_action_just_pressed("interact"):
		_index += 1
		_show_current()


func _enter_section(section: String) -> void:
	if not _sections.has(section):
		push_warning("DialogueBox: missing section '%s'" % section)
		_finish()
		return
	_section = _sections[section]
	_index = 0
	_show_current()


func _show_current() -> void:
	_in_choice = false
	_clear_choices()
	if _index >= _section.size():
		_finish()
		return

	var entry: Dictionary = _section[_index]
	if entry.has("goto"):
		_enter_section(entry["goto"])
		return
	if entry.has("set_flag"):
		GameState.set_flag(entry["set_flag"])
	if entry.has("choice"):
		_in_choice = true
		_choice_index = 0
		_refresh_choices()
		_hint.text = "[W/S] choose   [E] confirm"
		return

	_name_label.text = entry.get("speaker", "")
	_text_label.text = entry.get("text", "")
	_hint.text = "[E] continue"


func _refresh_choices() -> void:
	_clear_choices()
	var choices: Array = _section[_index]["choice"]
	for i in choices.size():
		var l := Label.new()
		l.text = ("> " if i == _choice_index else "   ") + choices[i]["text"]
		l.modulate = Color(1.0, 0.85, 0.4) if i == _choice_index else Color(1, 1, 1, 0.7)
		_choices_box.add_child(l)


func _clear_choices() -> void:
	for c in _choices_box.get_children():
		c.queue_free()


func _pick(i: int) -> void:
	var choice: Dictionary = _section[_index]["choice"][i]
	if choice.has("set_flag"):
		GameState.set_flag(choice["set_flag"])
	if choice.has("goto"):
		_enter_section(choice["goto"])
	else:
		_index += 1
		_show_current()


func _finish() -> void:
	visible = false
	finished.emit()
