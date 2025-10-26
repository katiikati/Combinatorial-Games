extends Area2D

var main_scene_path = NodePath("res://scripts+scenes/cafe/cafe.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var player_path: NodePath

var dialogue_started: bool = false
var connected_to_manager: bool = false

func _ready() -> void:
	_connect_to_manager()
	
func _connect_to_manager() -> void:
	if DialogueManager and not connected_to_manager:
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
		connected_to_manager = true
	elif not connected_to_manager:
		call_deferred("_connect_to_manager")

func action() -> void:
	if not dialogue_started and connected_to_manager: 
		#player.in_dialogue = true
		dialogue_started = true
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start, [self])

func _on_dialogue_ended(resource: DialogueResource) -> void:
	dialogue_started = false
	GameManager.player.in_dialogue = false
	
func play_chocolate_game() -> void:
	SceneManager.show_scene("res://scripts+scenes/main/main.tscn")
	
func next_scene():
	get_tree().change_scene_to_file(main_scene_path)
	
