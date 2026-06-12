extends CanvasLayer
## Dev-only live tuning panel. Toggle with F4 ("tuning_toggle").
## Builds one slider per float in the player's SkateTuning, grouped the same
## way as the resource, and edits the shared resource while the game runs.
## "Copy changed" puts the diff vs session start on the clipboard so the
## numbers can be pasted back into chat and persisted into skate_tuning.gd.

const PANEL_WIDTH := 340.0
const SLIDER_STEPS := 200.0

var _player: PlayerController
var _built := false
var _baseline := {}  # property name -> float at session start
var _sliders := {}  # property name -> HSlider
var _value_labels := {}  # property name -> Label
var _list: VBoxContainer


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("tuning_toggle"):
		visible = not visible
		if visible and not _built:
			_build()


func _build() -> void:
	_player = owner as PlayerController
	if _player == null or _player.tuning == null:
		return
	_built = true

	var root := PanelContainer.new()
	root.anchor_left = 1.0
	root.anchor_right = 1.0
	root.anchor_bottom = 1.0
	root.offset_left = -PANEL_WIDTH - 12.0
	root.offset_right = -12.0
	root.offset_top = 12.0
	root.offset_bottom = -12.0
	add_child(root)

	var vbox := VBoxContainer.new()
	root.add_child(vbox)

	var header := HBoxContainer.new()
	vbox.add_child(header)
	var title := Label.new()
	title.text = "TUNING (F4)"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	header.add_child(_make_button("Copy changed", _copy_changed))
	header.add_child(_make_button("Reset", _reset_all))

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)
	_list = VBoxContainer.new()
	_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_list)

	for prop in _player.tuning.get_property_list():
		if prop.usage & PROPERTY_USAGE_GROUP:
			_add_group_header(prop.name)
		elif prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE \
				and prop.type == TYPE_FLOAT:
			_add_row(prop.name)


func _add_group_header(text: String) -> void:
	var label := Label.new()
	label.text = text.to_upper()
	label.add_theme_color_override("font_color", Color(0.55, 0.75, 0.9))
	label.add_theme_font_size_override("font_size", 12)
	_list.add_child(label)


func _add_row(prop: String) -> void:
	var current: float = _player.tuning.get(prop)
	_baseline[prop] = current

	var name_row := HBoxContainer.new()
	_list.add_child(name_row)
	var name_label := Label.new()
	name_label.text = prop
	name_label.add_theme_font_size_override("font_size", 12)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_row.add_child(name_label)
	var value_label := Label.new()
	value_label.text = _fmt(current)
	value_label.add_theme_font_size_override("font_size", 12)
	name_row.add_child(value_label)
	_value_labels[prop] = value_label

	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = maxf(current * 3.0, 1.0)
	slider.step = slider.max_value / SLIDER_STEPS
	slider.value = current
	# Keep keyboard focus on the game: space must stay ollie, not a slider.
	slider.focus_mode = Control.FOCUS_NONE
	slider.value_changed.connect(func(v: float) -> void:
		_player.tuning.set(prop, v)
		value_label.text = _fmt(v)
	)
	_list.add_child(slider)
	_sliders[prop] = slider


func _make_button(text: String, pressed: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 12)
	button.pressed.connect(pressed)
	return button


func _copy_changed() -> void:
	var lines := PackedStringArray()
	for prop: String in _baseline:
		var current: float = _player.tuning.get(prop)
		if not is_equal_approx(current, _baseline[prop]):
			lines.append("%s = %s  # was %s" % [prop,
					_fmt(current), _fmt(_baseline[prop])])
	var text := "(no changes)" if lines.is_empty() else "\n".join(lines)
	DisplayServer.clipboard_set(text)
	print("[tuning] ", text.replace("\n", "\n[tuning] "))


func _reset_all() -> void:
	for prop: String in _baseline:
		_player.tuning.set(prop, _baseline[prop])
		_sliders[prop].set_value_no_signal(_baseline[prop])
		_value_labels[prop].text = _fmt(_baseline[prop])


func _fmt(v: float) -> String:
	return ("%.3f" % v).rstrip("0").rstrip(".")
