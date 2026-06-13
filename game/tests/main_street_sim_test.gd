extends Node
## Headless smoke test for the Main Street line: taps push down the whole line
## and confirms the graybox geometry is continuous — the player keeps rolling
## forward and reaches the Spillway approach without dropping into the void.
## Stops short of the Spillway gate so it never triggers a scene change.
## Run with: Godot --headless --path game res://tests/MainStreetSimTest.tscn

# Spillway gate sits near x=4940; require clearing the grade well past it-minus.
const APPROACH_X := 4500.0
const VOID_Y := 900.0

var route: Node2D
var player: CharacterBody2D
var t := 0.0
var fell := false
var max_x := -INF

# Planter hazard sits at x~2538; ollie it like a player would.
var jump_started := false
var jump_released := false
var jump_start_t := 0.0


func _ready() -> void:
	route = load("res://scenes/routes/MainStreet.tscn").instantiate()
	add_child(route)
	player = route.get_node("Player")


func _physics_process(delta: float) -> void:
	t += delta
	max_x = maxf(max_x, player.global_position.x)
	if player.global_position.y > VOID_Y:
		fell = true

	# One kick per press: tap every ~0.25 s like a player bombing the line.
	var f := Engine.get_physics_frames() % 30
	if f == 0:
		Input.action_press("push")
	elif f == 3:
		Input.action_release("push")

	# Charge an ollie before the curb (x~2538), release over it.
	if not jump_started and player.global_position.x > 2080.0 and player.is_on_floor():
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

	# Stop before the gate region so we never change scenes.
	if player.global_position.x > APPROACH_X or t > 18.0:
		var reached := max_x > APPROACH_X
		var ok := reached and not fell
		print("RESULT: reached_approach=%s  fell=%s  max_x=%.0f  time=%.2f" % [
			reached, fell, max_x, t])
		get_tree().quit(0 if ok else 1)
