extends Node2D

var player: Node2D

@onready var audio_player = $Audio

#scenes
@export var scene_paths: Array[String]

var coins = 0
var coins_label: Label

#chocolate
var squares_removed
var played_cocoa = 0

var typing_sounds = [
	preload("res://art/audio/sfx/typing/keypress-001.wav"),
	preload("res://art/audio/sfx/typing/keypress-002.wav"),
	preload("res://art/audio/sfx/typing/keypress-003.wav")
	]
	
var sfx = [
	preload("res://art/audio/sfx/click3.wav"), #click
	preload("res://art/audio/sfx/win sound 1.wav") #win
]

func random_type_sound():
	var random_sound = typing_sounds[randi() % typing_sounds.size()]
	audio_player.stream = random_sound
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()
	
func sfx_play(num: int):
	audio_player.play(sfx[num])

func coins_inc():
	coins += 1
	
func change_scene(num: int):
	var target_scene = scene_paths[num-1]
	get_tree().change_scene_to_file(target_scene)
