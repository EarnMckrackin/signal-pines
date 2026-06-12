class_name Camcorder
extends Node
## Eli's camcorder (Phase 5). Toggle with [C] once GameState has
## "has_camcorder". Raising it locks movement (player INTERACTING); hold the
## interact key on a framed EvidenceTarget to record it into GameState.
## Phase 6 hook: signal zones will glitch the viewfinder via apply_glitch().

const RECORD_TIME := 1.2
const RECORD_RANGE := 320.0
const STILL_SPEED := 80.0

var active := false

var _player: PlayerController
var _layer: CanvasLayer
var _rec: Label
var _info: Label
var _progress := 0.0
var _flash := 0.0
var _target: EvidenceTarget


func _ready() -> void:
	_player = owner as PlayerController
	_build_viewfinder()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("camcorder") and GameState.has_flag("has_camcorder"):
		if active:
			_deactivate()
		elif _can_activate():
			_activate()

	if not active:
		return

	# Blinking REC dot, like every tape Eli ever labeled wrong.
	_rec.visible = fmod(Time.get_ticks_msec() / 1000.0, 1.0) < 0.65

	if _flash > 0.0:
		_flash -= delta
		if _flash <= 0.0:
			_progress = 0.0
		return

	_target = _find_target()
	if _target != null and Input.is_action_pressed("interact"):
		_progress += delta
		if _progress >= RECORD_TIME:
			GameState.add_evidence(_target.evidence_id)
			_info.text = "CAPTURED: %s" % _target.display_name
			_flash = 1.4
			return
	else:
		_progress = maxf(_progress - 2.0 * delta, 0.0)

	if _target == null:
		_info.text = "nothing worth filming here"
	else:
		var filled := int(_progress / RECORD_TIME * 10.0)
		_info.text = "FILMING: %s   hold [E]  [%s%s]" % [
			_target.display_name, "#".repeat(filled), ".".repeat(10 - filled),
		]


func _can_activate() -> bool:
	return not _player.is_busy() \
			and _player.state in [SkateState.ON_FOOT, SkateState.SKATING] \
			and _player.velocity.length() < STILL_SPEED


func _activate() -> void:
	active = true
	_progress = 0.0
	_flash = 0.0
	_player.begin_interaction()
	_layer.visible = true


func _deactivate() -> void:
	active = false
	_layer.visible = false
	_player.end_interaction()


func _find_target() -> EvidenceTarget:
	var best: EvidenceTarget = null
	var best_d := RECORD_RANGE
	for t: EvidenceTarget in get_tree().get_nodes_in_group("evidence"):
		if GameState.has_evidence(t.evidence_id):
			continue
		# Must be roughly in front of the lens.
		if signf(t.global_position.x - _player.global_position.x) * _player.facing < 0.0:
			continue
		var d := _player.global_position.distance_to(t.global_position)
		if d < best_d:
			best_d = d
			best = t
	return best


# --- Viewfinder UI (placeholder; VHS shader comes with the art pass) ---------


func _build_viewfinder() -> void:
	_layer = CanvasLayer.new()
	_layer.layer = 60
	_layer.visible = false
	add_child(_layer)

	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_layer.add_child(root)

	# Thin frame bars inset from the screen edge.
	for bar_cfg: Array in [
		[Control.PRESET_TOP_WIDE, Vector2(0, 3)],
		[Control.PRESET_BOTTOM_WIDE, Vector2(0, 3)],
		[Control.PRESET_LEFT_WIDE, Vector2(3, 0)],
		[Control.PRESET_RIGHT_WIDE, Vector2(3, 0)],
	]:
		var bar := ColorRect.new()
		bar.color = Color(1, 1, 1, 0.5)
		bar.set_anchors_preset(bar_cfg[0])
		if bar_cfg[1].x > 0:
			bar.custom_minimum_size = Vector2(bar_cfg[1].x, 0)
			bar.offset_top = 24.0
			bar.offset_bottom = -24.0
			if bar_cfg[0] == Control.PRESET_LEFT_WIDE:
				bar.offset_left = 24.0
				bar.offset_right = 24.0 + bar_cfg[1].x
			else:
				bar.offset_left = -24.0 - bar_cfg[1].x
				bar.offset_right = -24.0
		else:
			bar.custom_minimum_size = Vector2(0, bar_cfg[1].y)
			bar.offset_left = 24.0
			bar.offset_right = -24.0
			if bar_cfg[0] == Control.PRESET_TOP_WIDE:
				bar.offset_top = 18.0
				bar.offset_bottom = 18.0 + bar_cfg[1].y
			else:
				bar.offset_top = -18.0 - bar_cfg[1].y
				bar.offset_bottom = -18.0
		root.add_child(bar)

	_rec = Label.new()
	_rec.text = "@ REC"
	_rec.modulate = Color(1.0, 0.25, 0.2)
	_rec.position = Vector2(40, 34)
	root.add_child(_rec)

	var stamp := Label.new()
	stamp.text = "JUN 12 1986   PM 7:58"
	stamp.modulate = Color(1, 1, 1, 0.7)
	stamp.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	stamp.offset_left = 40.0
	stamp.offset_top = -64.0
	root.add_child(stamp)

	_info = Label.new()
	_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_info.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_info.offset_top = -100.0
	_info.offset_bottom = -76.0
	root.add_child(_info)
