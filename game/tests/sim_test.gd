extends Node
## Headless smoke test: taps push down Mercy Hill, ollies the curb, then
## ollies onto the rail over The Drop, grinds it (hold brake in air), ollies
## off, lands, and reports whether the finish gate fired. Run with:
##   Godot --headless --path game res://tests/SimTest.tscn

var route: Node2D
var player: CharacterBody2D
var t := 0.0

# Curb ollie (x ~2000).
var jump_started := false
var jump_released := false
var jump_start_t := 0.0

# Rail grind (rail spans x 2350..3206 above The Drop).
var grind_jump_started := false
var grind_jump_released := false
var grind_jump_t := 0.0
var grind_entered := false
var grind_enter_t := 0.0
var grind_exit_jumped := false
var grind_exited_airborne := false
var landed_after_grind := false


func _ready() -> void:
	route = load("res://scenes/routes/MercyHill.tscn").instantiate()
	add_child(route)
	player = route.get_node("Player")
	player.state_changed.connect(_on_state_changed)


func _on_state_changed(previous: int, current: int) -> void:
	if current == SkateState.GRINDING:
		grind_entered = true
		grind_enter_t = t
	if previous == SkateState.GRINDING and current == SkateState.AIRBORNE:
		grind_exited_airborne = true
	if grind_exited_airborne and previous == SkateState.AIRBORNE \
			and current == SkateState.SKATING:
		landed_after_grind = true


func _physics_process(delta: float) -> void:
	t += delta

	# Push is one kick per press now, so tap it every ~0.25 s like a player.
	var f := Engine.get_physics_frames() % 30
	if f == 0:
		Input.action_press("push")
	elif f == 3:
		Input.action_release("push")

	# Charge an ollie before the curb at x=2000, release after 0.35 s.
	if not jump_started and player.global_position.x > 1550.0 and player.is_on_floor():
		jump_started = true
		jump_start_t = t
		Input.action_press("ollie")
	if jump_started and not jump_released and t - jump_start_t > 0.35:
		jump_released = true
		Input.action_release("ollie")

	# Past the curb: charge again at the top of The Drop, release under the
	# rail, then hold brake in the air to snap onto it.
	if jump_released and not grind_jump_started \
			and player.global_position.x > 2330.0 and player.is_on_floor():
		grind_jump_started = true
		grind_jump_t = t
		Input.action_press("ollie")
	if grind_jump_started and not grind_jump_released and t - grind_jump_t > 0.3:
		grind_jump_released = true
		Input.action_release("ollie")
	if grind_jump_released and not grind_entered and player.state == SkateState.AIRBORNE:
		Input.action_press("brake")

	# Grind for 0.6 s, then ollie off; once the grind has ended by any path,
	# release everything so the landing rolls out clean.
	if grind_entered and not grind_exit_jumped and player.state == SkateState.GRINDING \
			and t - grind_enter_t > 0.6:
		grind_exit_jumped = true
		Input.action_press("ollie")
	if grind_entered and player.state != SkateState.GRINDING:
		Input.action_release("brake")
		if grind_exit_jumped:
			Input.action_release("ollie")

	if Engine.get_physics_frames() % 120 == 0:
		print("t=%4.1f  x=%5.0f y=%4.0f  speed=%4.0f  state=%-12s floor=%s" % [
			t, player.global_position.x, player.global_position.y,
			player.velocity.length(),
			SkateState.NAMES.get(player.state, "?"), player.is_on_floor(),
		])

	if t > 16.0:
		var ok: bool = route._run_finished and grind_entered \
				and grind_exited_airborne and landed_after_grind
		print("RESULT: finished=%s  grind_entered=%s  grind_exit_airborne=%s  landed_after_grind=%s  time=%.2f  final_x=%.0f" % [
			route._run_finished, grind_entered, grind_exited_airborne,
			landed_after_grind, route._run_time, player.global_position.x])
		get_tree().quit(0 if ok else 1)
