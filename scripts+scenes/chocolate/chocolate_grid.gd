extends GridContainer

var start_game = false

@export var rows := 6
@export var cols := 8
@export var piece_scene: PackedScene
@export var distance :=1.1

@onready var chomp_logic = get_tree().get_first_node_in_group("chomp_logic")
@onready var ui = get_tree().get_first_node_in_group("ui")

var last_selected: TextureRect = null
var current_row:int
var current_col: int

var prev_row: int
var prev_col: int

var deleted_points = []
var existing_points = []
var just_added: Vector2

var can_move = true

func _ready():
	current_row = rows-1
	current_col = cols-1
	prev_row = current_row
	prev_col = current_col
	
	var x_offset = (cols - 1) * distance * 0.5
	var y_offset = (rows - 1) * distance * 0.5
	
	#spawn chocolate squares
	for r in range(rows):
		for c in range(cols):
			var piece = piece_scene.instantiate()
			piece.position = Vector2(c * distance -x_offset, r * distance-y_offset)
			if c == 0 && r == 0:
				var piece_sprite: TextureRect = piece
				#var mat: Material = piece_mesh.material
				piece_sprite.modulate = Color(1, 0, 0) # red
				#piece_mesh.set_surface_override_material(0, mat)
			piece.row = r
			piece.col = c
			existing_points.append(Vector2(r, c))
			add_child(piece)
	update_selection()
			
func _unhandled_input(event: InputEvent):
	if !start_game || !can_move:
		return
	
	#stuff when keys are pressed
	if event is InputEventKey && event.pressed:
		var moved = false
		
		if event.is_action_pressed("up"):
			prev_row = current_row
			current_row += 1
			moved = true
			
		if event.is_action_pressed("down"):
			prev_row = current_row
			current_row -= 1
			moved = true
			
		if event.is_action_pressed("right"):
			prev_col = current_col
			current_col += 1
			moved = true
			
		if event.is_action_pressed("left"):
			prev_col = current_col
			current_col -= 1
			moved = true
		
		if moved:
			update_selection()
			
		if event.is_action_pressed("enter"):
			eat_chunk()

func update_selection():
	#after WASD key pressed
	if !Vector2(current_row, current_col) in existing_points:
		if Vector2(prev_row, current_col) in existing_points:
			current_row = prev_row
		elif Vector2(current_row, prev_col) in existing_points:
			current_col = prev_col
		
	for child in get_children():
		child.set_selected(false)
		if child.row == current_row && child.col == current_col:
			last_selected = child
			
	last_selected.set_selected(true)
	
func get_next_select():
	#after chunk eaten, get new selected square
	for child in get_children():
		child.set_selected(false)
		var child_point = Vector2(child.row, child.col)
		if child_point in existing_points:
			last_selected = child
			
	last_selected.set_selected(true)
	current_row = last_selected.row
	current_col = last_selected.col
			
func eat_chunk():
	if ui.player_num == 1:
		chomp_logic.apply_move(current_row, current_col)
	if current_row == 0 && current_col == 0:
		ui.end_game(false)
		return
		
	just_added=Vector2(current_row, current_col)
	var set_new_current = false
	for child in get_children():
		if child.row >= current_row && child.col >= current_col:
			var bad_point = Vector2(child.row, child.col)
			deleted_points.append(bad_point)
			existing_points.erase(bad_point)
			child.queue_free()
	
	if !set_new_current:
		current_col -= 1
		current_row -= 1
		if current_row < 0:
			current_row = 0
		if current_col < 0:
			current_col = 0
		set_new_current = true
		get_next_select()
		
	ui.next_play()
	
func eat_given_chunk(chunk: Vector2):
	#eat a chunk given from best move in single play algorithm
	if chunk.x == 0 && chunk.y == 0:
		ui.end_game(true)
		return
		
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
	get_next_select()
