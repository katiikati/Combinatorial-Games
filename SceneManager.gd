extends Node

var loaded_scenes := {}
var current_scene: Node

func show_scene(scene_path: String):
	current_scene.hide()

	if scene_path in loaded_scenes:
		current_scene = loaded_scenes[scene_path]
	else:
		var scene = load(scene_path).instantiate()
		add_child(scene)
		loaded_scenes[scene_path] = scene
		current_scene = scene
		
	current_scene.show()
