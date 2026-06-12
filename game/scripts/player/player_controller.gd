class_name PlayerController
extends CharacterBody2D
## Side-view skate controller for the "The Mouth" vertical slice.
## Input is read here, feel numbers live in SkateTuning, state ids in SkateState.
## Extension points: grind (Phase 3) hooks into _physics_process via a new
## GRINDING branch; gadgets/animation listen to state_changed.

signal state_changed(previous: int, current: int)

@export var tuning: SkateTuning

var state: int = SkateState.SKATING
var facing := 1
var spawn_point := Vector2.ZERO
var crouch_charge := 0.0

# Signed speed along the floor surface (+ = screen right). Authoritative while
# grounded: move_and_slide() flattens velocity.y on slopes, so re-deriving
# speed from velocity every frame would silently bleed it away.
var _ground_speed := 0.0
var _push_cooldown := 0.0
var _coyote_timer := 0.0
var _jump_buffer := 0.0
var _state_timer := 0.0
var _was_on_floor := false
var _airborne_on_foot := false
var _pre_move_velocity := Vector2.ZERO

@onready var _visual: Node2D = $Visual
@onready var _body_poly: Polygon2D = $Visual/Body
@onready var _board: Polygon2D = $Visual/Board


func _ready() -> void:
	if tuning == null:
		tuning = SkateTuning.new()
	spawn_point = global_position
	floor_snap_length = 24.0
	floor_max_angle = deg_to_rad(60.0)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		respawn()
		return

	_push_cooldown = maxf(_push_cooldown - delta, 0.0)
	_jump_buffer = maxf(_jump_buffer - delta, 0.0)
	_coyote_timer = maxf(_coyote_timer - delta, 0.0)
	if Input.is_action_just_pressed("ollie"):
		_jump_buffer = tuning.jump_buffer_time

	match state:
		SkateState.ON_FOOT:
			_process_on_foot(delta)
		SkateState.SKATING, SkateState.CROUCHING, SkateState.POWERSLIDING:
			_process_skating(delta)
		SkateState.AIRBORNE:
			_process_airborne(delta)
		SkateState.BAILING:
			_process_bailing(delta)
		SkateState.RECOVERING:
			_process_recovering(delta)

	_pre_move_velocity = velocity
	move_and_slide()
	_after_move()
	_update_visual(delta)


func respawn() -> void:
	global_position = spawn_point
	velocity = Vector2.ZERO
	_ground_speed = 0.0
	crouch_charge = 0.0
	_visual.rotation = 0.0
	_set_state(SkateState.SKATING)


# --- States -----------------------------------------------------------------


func _process_skating(delta: float) -> void:
	if not is_on_floor():
		_coyote_timer = tuning.coyote_time
		_set_state(SkateState.AIRBORNE)
		_process_airborne(delta)
		return

	if Input.is_action_just_pressed("mount_toggle"):
		_set_state(SkateState.ON_FOOT)
		return

	var lean := Input.get_axis("lean_left", "lean_right")
	var surf := _surface_dir()
	var speed := _ground_speed

	# Slope momentum: gravity projected along the surface. surf.y > 0 means
	# the surface descends to the right, so rightward speed grows downhill.
	speed += tuning.gravity * surf.y * tuning.slope_grip * delta

	if Input.is_action_pressed("brake"):
		if absf(speed) >= tuning.powerslide_min_speed:
			_set_state(SkateState.POWERSLIDING)
			speed = move_toward(speed, 0.0, tuning.powerslide_friction * delta)
		else:
			if state == SkateState.POWERSLIDING:
				_set_state(SkateState.SKATING)
			speed = move_toward(speed, 0.0, tuning.brake_friction * delta)
	else:
		if state == SkateState.POWERSLIDING:
			_set_state(SkateState.SKATING)
		speed = move_toward(speed, 0.0, tuning.ground_friction * delta)
		if Input.is_action_pressed("push") and _push_cooldown == 0.0 \
				and absf(speed) < tuning.max_push_speed:
			speed = clampf(speed + facing * tuning.push_impulse,
					-tuning.max_push_speed, tuning.max_push_speed)
			_push_cooldown = tuning.push_interval
		# Gentle tic-tac accel so the player can start or turn around from rest.
		speed += lean * tuning.lean_accel * delta

	if absf(lean) > 0.3 and absf(speed) < 40.0:
		facing = -1 if lean < 0.0 else 1
	elif absf(speed) > 40.0:
		facing = 1 if speed > 0.0 else -1

	# Crouch charges the ollie; release pops it.
	if Input.is_action_pressed("ollie"):
		if state != SkateState.POWERSLIDING:
			_set_state(SkateState.CROUCHING)
		crouch_charge = minf(crouch_charge + delta, tuning.crouch_charge_time)
	elif Input.is_action_just_released("ollie"):
		_ground_speed = clampf(speed, -tuning.absolute_max_speed, tuning.absolute_max_speed)
		velocity = surf * _ground_speed
		_ollie()
		return
	elif state == SkateState.CROUCHING:
		crouch_charge = 0.0
		_set_state(SkateState.SKATING)

	_ground_speed = clampf(speed, -tuning.absolute_max_speed, tuning.absolute_max_speed)
	velocity = surf * _ground_speed


func _process_airborne(delta: float) -> void:
	var lean := Input.get_axis("lean_left", "lean_right")
	velocity.x += lean * tuning.air_control * delta
	velocity.x = move_toward(velocity.x, 0.0, tuning.air_drag * delta)
	velocity.y = minf(velocity.y + tuning.gravity * delta, tuning.max_fall_speed)
	# Coyote ollie: jump pressed just after rolling off an edge.
	if _coyote_timer > 0.0 and Input.is_action_just_pressed("ollie") \
			and not _airborne_on_foot:
		_coyote_timer = 0.0
		_jump_buffer = 0.0
		velocity.y = -tuning.ollie_force_min


func _process_on_foot(delta: float) -> void:
	var lean := Input.get_axis("lean_left", "lean_right")
	velocity.x = move_toward(velocity.x, lean * tuning.walk_speed, tuning.walk_accel * delta)
	if absf(lean) > 0.3:
		facing = -1 if lean < 0.0 else 1
	if is_on_floor():
		if Input.is_action_just_pressed("ollie"):
			velocity.y = -tuning.foot_jump_force
			_airborne_on_foot = true
			_set_state(SkateState.AIRBORNE)
			return
		if Input.is_action_just_pressed("mount_toggle"):
			_ground_speed = velocity.dot(_surface_dir())
			_set_state(SkateState.SKATING)
			return
	else:
		velocity.y = minf(velocity.y + tuning.gravity * delta, tuning.max_fall_speed)


func _process_bailing(delta: float) -> void:
	velocity.y = minf(velocity.y + tuning.gravity * delta, tuning.max_fall_speed)
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, tuning.ground_friction * 4.0 * delta)
	_state_timer -= delta
	if _state_timer <= 0.0:
		_state_timer = tuning.recover_duration
		_set_state(SkateState.RECOVERING)


func _process_recovering(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, tuning.brake_friction * delta)
	if not is_on_floor():
		velocity.y = minf(velocity.y + tuning.gravity * delta, tuning.max_fall_speed)
	_state_timer -= delta
	if _state_timer <= 0.0:
		_ground_speed = velocity.dot(_surface_dir())
		_set_state(SkateState.SKATING)


# --- Transitions ------------------------------------------------------------


func _ollie() -> void:
	var charge_t := crouch_charge / tuning.crouch_charge_time
	var force := lerpf(tuning.ollie_force_min, tuning.ollie_force_max, charge_t)
	crouch_charge = 0.0
	_jump_buffer = 0.0
	_airborne_on_foot = false
	velocity.y = -force
	_set_state(SkateState.AIRBORNE)


func _bail() -> void:
	crouch_charge = 0.0
	_state_timer = tuning.bail_duration
	velocity = Vector2(-facing * 140.0, -240.0)
	_set_state(SkateState.BAILING)


func _after_move() -> void:
	var on_floor := is_on_floor()

	if state == SkateState.AIRBORNE and on_floor:
		if _airborne_on_foot:
			_airborne_on_foot = false
			_set_state(SkateState.ON_FOOT)
		else:
			# Landing keeps the along-surface component of the fall.
			_ground_speed = velocity.dot(_surface_dir())
			_set_state(SkateState.SKATING)
			if _jump_buffer > 0.0:
				_ollie()

	# Wall slams at speed read as bails; slow bumps just stop the player.
	if state in [SkateState.SKATING, SkateState.CROUCHING,
			SkateState.POWERSLIDING, SkateState.AIRBORNE]:
		for i in get_slide_collision_count():
			var col := get_slide_collision(i)
			var n := col.get_normal()
			if absf(n.x) > 0.7:
				if _pre_move_velocity.dot(n) < -tuning.bail_impact_speed:
					_bail()
				else:
					_ground_speed = 0.0
				break

	_was_on_floor = on_floor


func _set_state(next: int) -> void:
	if next == state:
		return
	var previous := state
	state = next
	state_changed.emit(previous, next)


func _surface_dir() -> Vector2:
	# Unit vector along the floor pointing screen-right. On flat ground this
	# is (1, 0); on a descending slope its y component is positive.
	if is_on_floor():
		var n := get_floor_normal()
		return Vector2(-n.y, n.x)
	return Vector2.RIGHT


# --- Placeholder visuals ----------------------------------------------------


func _update_visual(delta: float) -> void:
	if state == SkateState.BAILING:
		_visual.rotation += facing * 10.0 * delta
	else:
		var target_rot := 0.0
		if is_on_floor():
			target_rot = _surface_dir().angle()
		elif state == SkateState.AIRBORNE:
			target_rot = clampf(velocity.y * 0.0004, -0.3, 0.3) * facing
		_visual.rotation = lerp_angle(_visual.rotation, target_rot, 12.0 * delta)

	_visual.scale.x = float(facing)

	var crouched := state == SkateState.CROUCHING or state == SkateState.POWERSLIDING
	_body_poly.scale.y = lerpf(_body_poly.scale.y, 0.6 if crouched else 1.0, 14.0 * delta)
	# TODO(Phase 7): show the board carried under the arm instead of hiding it.
	_board.visible = state != SkateState.ON_FOOT
