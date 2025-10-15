extends Node

var loaded_scenes := {}
var current_scene: Node
var scene_data: Dictionary = {}

func show_scene(scene_path: String):
	if current_scene:
		save_scene_state(current_scene, scene_path)
		print("current scene false ", current_scene)

	get_tree().change_scene_to_file(scene_path)
	
	if scene_path in scene_data:
		restore_scene_state(current_scene, scene_data[scene_path])
		
func save_scene_state(scene: Node, next_path: String) -> void:
	if scene.name == "cafe":
		var player = scene.get_node("Player")
		scene_data["res://scripts+scenes/cafe/cafe.tscn"] = {
			"player_pos": player.global_position
			}
		
	current_scene.show()
	
func restore_scene_state(scene: Node, data: Dictionary) -> void:
	if scene.name == "Cafe" and data.has("player_pos"):
		var player = scene.get_node("Player")
		player.global_position = data["player_pos"]
		
func _set_active(node: Node, active: bool) -> void:
	node.set_process(active)
	node.set_physics_process(active)
	node.set_process_input(active)
	if node is CanvasItem:
		node.visible = active
	if node is Control:
		node.mouse_filter = Control.MOUSE_FILTER_STOP if active else Control.MOUSE_FILTER_IGNORE
		for child in node.get_children():
			_set_active(child, active)
