extends StaticBody3D

signal piece_clicked(row, col)

@onready var selection_frame = $ChocolateMesh/Glow
@onready var label = $ChocolateMesh/Label

var row
var col

func _ready():
	label.text = str(row) + " " + str(col)
	label.position = Vector2(position.x, position.y)

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("clicked")
		emit_signal("piece clicked", row, col)

func set_selected(selected: bool):
	selection_frame.visible = selected
	
