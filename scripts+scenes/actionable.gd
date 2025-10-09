extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var player_path: NodePath
var player: CharacterBody2D

var dialogue_started: bool = false
var connected_to_manager: bool = false

func _ready() -> void:
	if !has_node("../../Player"):
		return
	player_path = NodePath("../../Player")
	player = get_node(player_path)
	_connect_to_manager()

func _connect_to_manager() -> void:
	if DialogueManager and not connected_to_manager:
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
		connected_to_manager = true
	elif not connected_to_manager:
		call_deferred("_connect_to_manager")

func action() -> void:
	if not dialogue_started and connected_to_manager: 
		player.in_dialogue = true
		dialogue_started = true
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_dialogue_ended(resource: DialogueResource) -> void:
	dialogue_started = false
	player.in_dialogue = false
