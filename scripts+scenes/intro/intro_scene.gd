extends Control

var main_scene_path = NodePath("res://scripts+scenes/cafe/cafe.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var dialogue_started: bool = false
var connected_to_manager: bool = false

func _ready() -> void:
	_connect_to_manager()
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start, [self])
	
func _connect_to_manager() -> void:
	if DialogueManager and not connected_to_manager:
		connected_to_manager = true
	elif not connected_to_manager:
		call_deferred("_connect_to_manager")
		
func next_scene():
	get_tree().change_scene_to_file(main_scene_path)
