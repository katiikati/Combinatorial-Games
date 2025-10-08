extends StaticBody3D

signal piece_clicked(row, col)

@onready var selection_frame = $ChocolateMesh/Glow

var row
var col

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("clicked")
		emit_signal("piece clicked", row, col)

func set_selected(selected: bool):
	selection_frame.visible = selected
	
