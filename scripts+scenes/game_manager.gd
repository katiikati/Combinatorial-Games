extends Node2D

var player: Node2D

@onready var audio_player = $AudioStreamPlayer
var coins = 0
var coins_label: Label

var squares_removed

var played_cocoa = 0

var typing_sounds = [
	preload("res://art/audio/sfx/typing/keypress-001.wav"),
	preload("res://art/audio/sfx/typing/keypress-002.wav"),
	preload("res://art/audio/sfx/typing/keypress-003.wav")
	]

func random_type_sound():
	var random_sound = typing_sounds[randi() % typing_sounds.size()]
	audio_player.stream = random_sound
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()

func coins_inc():
	coins += 1
