extends Node2D

@export var parallax_strength := 0.03
@onready var layers: Array[Node] = $Parallax2D.get_children()
@export var layer_strengths: Array[int] = [3, 1, 5]

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_center = get_viewport_rect().size / 2
	var offset = (mouse_pos - screen_center) * parallax_strength

	for i in range(layers.size()):
		var layer = layers[i]
		if layer:
			layer.position = offset * (layer_strengths[i] + 1)
