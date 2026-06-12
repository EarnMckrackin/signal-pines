extends CanvasLayer
## Dev-only readout for movement tuning. Toggle with F3.

@onready var _label: Label = $Panel/Label

var _player: PlayerController


func _ready() -> void:
	_player = owner as PlayerController


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_toggle"):
		visible = not visible
	if not visible or _player == null:
		return
	var charge_pct := 0.0
	if _player.tuning.crouch_charge_time > 0.0:
		charge_pct = 100.0 * _player.crouch_charge / _player.tuning.crouch_charge_time
	_label.text = "state: %s\nspeed: %.0f\nvel: (%.0f, %.0f)\ngrounded: %s\nfacing: %d\ncharge: %.0f%%\nfps: %d" % [
		SkateState.NAMES.get(_player.state, "?"),
		_player.velocity.length(),
		_player.velocity.x, _player.velocity.y,
		_player.is_on_floor(),
		_player.facing,
		charge_pct,
		Engine.get_frames_per_second(),
	]
