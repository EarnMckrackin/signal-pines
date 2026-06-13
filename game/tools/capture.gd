extends Node
## Screenshot harness for visual review. Loads a route, lets particles/parallax
## settle (optionally nudging the player downhill so parallax depth shows), then
## saves the viewport to PNG and quits. Windowed (not headless — needs a GPU).
## Usage:
##   Godot --path . res://tools/Capture.tscn -- <scene_path> <out_png> [roll_frames]

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var scene_path: String = args[0]
	var out_path: String = args[1]
	var settle_frames := int(args[2]) if args.size() > 2 else 150
	var start_x := float(args[3]) if args.size() > 3 else INF

	var scene: Node = load(scene_path).instantiate()
	add_child(scene)
	await get_tree().process_frame

	# Drop the player at a vantage that shows the route's depth, then let it
	# settle on the ground and warm up particles/parallax.
	var player := scene.get_node_or_null("Player")
	if player != null and start_x != INF:
		player.global_position.x = start_x

	# Hide gameplay HUD/debug CanvasLayers (layer >= 0) so the shot is pure
	# environment; the sky lives at layer -100 and stays.
	_hide_huds(scene)

	for i in settle_frames:
		await get_tree().process_frame

	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png(out_path)
	print("captured ", out_path, "  (", img.get_width(), "x", img.get_height(), ")")
	get_tree().quit()


func _hide_huds(node: Node) -> void:
	for child in node.get_children():
		if child is CanvasLayer and (child as CanvasLayer).layer >= 0:
			(child as CanvasLayer).visible = false
		_hide_huds(child)
