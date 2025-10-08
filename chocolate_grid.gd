extends GridContainer

var start_game = false

@export var rows := 6
@export var cols := 8
@export var piece_scene: PackedScene
@export var distance :=1.1

@onready var ui = get_tree().get_first_node_in_group("ui")

var last_selected: Node3D = null
var current_row:int
var current_col: int

var deleted_points = []
var existing_points = []
var just_added: Vector2

func _ready():
	current_row = rows-1
	current_col = cols-1
	
	var x_offset = (cols - 1) * distance * 0.5
	var y_offset = (rows - 1) * distance * 0.5
	
	for r in range(rows):
		for c in range(cols):
			var piece = piece_scene.instantiate()
			piece.position = Vector3(c * distance -x_offset, r * distance-y_offset, 0)
			if c == 0 && r == 0:
				var piece_mesh = piece.get_node("ChocolateMesh")
				var mat = piece_mesh.get_active_material(0).duplicate()
				mat.albedo_color = Color(1, 0, 0) # red
				piece_mesh.set_surface_override_material(0, mat)
			piece.row = r
			piece.col = c
			existing_points.append(Vector2(r, c))
			add_child(piece)
	update_selection()
			
func _unhandled_input(event: InputEvent):
	if !start_game:
		return
	
	if event is InputEventKey && event.pressed:
		var moved = false
		
		if event.is_action_pressed("up"):
			current_row += 1
			moved = true
			
		if event.is_action_pressed("down"):
			current_row -= 1
			moved = true
			
		if event.is_action_pressed("right"):
			current_col += 1
			moved = true
			
		if event.is_action_pressed("left"):
			current_col -= 1
			moved = true
			
		if current_row < 0:
			current_row = 0
		if current_row > rows-1:
			current_row = rows-1
		if current_col < 0:
			current_col = 0
		if current_col > cols-1:
			current_col = cols-1
		
		if moved:
			update_selection()
			
		if event.is_action_pressed("enter"):
			eat_chunk()

func update_selection():
	for child in get_children():
		child.set_selected(false)
		var child_point = Vector2(child.row, child.col)
		if child_point in existing_points:
			last_selected = child
			
	last_selected.set_selected(true)
			
func eat_chunk():
	
	if current_row == 0 && current_col == 0:
		ui.lost()
		return
		
	var set_new_current = false
	for child in get_children():
		if child.row >= current_row && child.col >= current_col:
			var bad_point = Vector2(child.row, child.col)
			deleted_points.append(bad_point)
			existing_points.erase(bad_point)
			just_added=Vector2(child.row, child.col)
			child.queue_free()
	
	if !set_new_current:
		current_col -= 1
		current_row -= 1
		if current_row < 0:
			current_row = 0
		if current_col < 0:
			current_col = 0
		set_new_current = true
		update_selection()
		
	ui.next_play()
	
func eat_given_chunk(chunk: Vector2):
	just_added=Vector2(chunk.x, chunk.y)
	for child in get_children():
		if child.row >= chunk.x && child.col >= chunk.y:
			var bad_point = Vector2(child.row, child.col)
			deleted_points.append(bad_point)
			existing_points.erase(bad_point)
			child.queue_free()
	current_col = chunk.x - 1
	current_row = chunk.y - 1
	if current_row < 0:
		current_row = 0
	if current_col < 0:
		current_col = 0
	update_selection()
