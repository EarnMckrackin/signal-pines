extends Node
## Headless smoke test for the Tunnel Traversal Toy (Phase 7): walks right,
## crawls the duct, wades the pool, climbs the ladder, shoves the door, and
## reaches the exit pad. Run with:
##   Godot --headless --path game res://tests/TunnelToySimTest.tscn

var toy: Node2D
var player: PlayerController
var t := 0.0

var crawled := false
var climbed := false
var waded := false


func _ready() -> void:
	toy = load("res://scenes/toys/TunnelToy.tscn").instantiate()
	add_child(toy)
	player = toy.get_node("Player")
	player.state_changed.connect(_on_state_changed)


func _on_state_changed(_previous: int, current: int) -> void:
	if current == SkateState.CRAWLING:
		crawled = true
	if current == SkateState.CLIMBING:
		climbed = true


func _physics_process(delta: float) -> void:
	t += delta
	var x := player.global_position.x
	var on_gallery := player.global_position.y < -160.0

	# Always heading right.
	Input.action_press("lean_right")

	if player.water_zones > 0:
		waded = true

	# Duct: crawl while under / approaching the slab.
	if x > 340.0 and x < 840.0 and not on_gallery:
		Input.action_press("brake")
	else:
		Input.action_release("brake")

	# Ladder: hold climb from the approach until we're up past the lip.
	if x > 1500.0 and not on_gallery:
		Input.action_press("push")
	elif on_gallery or player.state != SkateState.CLIMBING:
		Input.action_release("push")

	# Door: shove while close.
	if on_gallery and x > 2140.0 and not GameState.has_flag("tunnel_door_wedged"):
		Input.action_press("interact")
	else:
		Input.action_release("interact")

	if Engine.get_physics_frames() % 120 == 0:
		print("t=%4.1f  x=%5.0f y=%4.0f  state=%-12s  climbable=%d water=%d headroom=%s" % [
			t, x, player.global_position.y,
			SkateState.NAMES.get(player.state, "?"),
			player.climbable_zones, player.water_zones,
			player.crawl_headroom_blocked,
		])

	if t > 25.0 or (toy._finished and t > 1.0):
		var door: bool = GameState.has_flag("tunnel_door_wedged")
		var ok: bool = crawled and waded and climbed and door and toy._finished
		print("RESULT: crawled=%s waded=%s climbed=%s door=%s finished=%s time=%.2f final_x=%.0f" % [
			crawled, waded, climbed, door, toy._finished, toy._time,
			player.global_position.x])
		get_tree().quit(0 if ok else 1)
