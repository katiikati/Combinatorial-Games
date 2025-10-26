extends TextureRect

signal piece_clicked(row, col)

@onready var selection_frame = $Glow

var row
var col

func _input_event(vp, event, i):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("piece clicked", row, col)

func set_selected(selected: bool):
	selection_frame.visible = selected
	
