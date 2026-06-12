extends Node
## Headless smoke test: holds push down Mercy Hill, ollies the curb, and
## reports whether the finish gate fired. Run with:
##   Godot --headless --path game res://tests/SimTest.tscn

var route: Node2D
var player: CharacterBody2D
var t := 0.0
var jump_started := false
var jump_released := false
var jump_start_t := 0.0


func _ready() -> void:
	route = load("res://scenes/routes/MercyHill.tscn").instantiate()
	add_child(route)
	player = route.get_node("Player")
	Input.action_press("push")


func _physics_process(delta: float) -> void:
	t += delta

	# Charge an ollie before the curb at x=2000, release after 0.35 s.
	if not jump_started and player.global_position.x > 1550.0 and player.is_on_floor():
		jump_started = true
		jump_start_t = t
		Input.action_press("ollie")
	if jump_started and not jump_released and t - jump_start_t > 0.35:
		jump_released = true
		Input.action_release("ollie")

	if Engine.get_physics_frames() % 120 == 0:
		print("t=%4.1f  x=%5.0f y=%4.0f  speed=%4.0f  state=%-12s floor=%s" % [
			t, player.global_position.x, player.global_position.y,
			player.velocity.length(),
			SkateState.NAMES.get(player.state, "?"), player.is_on_floor(),
		])

	if t > 16.0:
		print("RESULT: finished=%s  time=%.2f  final_x=%.0f" % [
			route._run_finished, route._run_time, player.global_position.x])
		get_tree().quit(0 if route._run_finished else 1)
