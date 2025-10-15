extends Control

var current_player = 1
var player_num = 1

@onready var choco_grid = get_tree().get_first_node_in_group("choco-grid")
@onready var chomp_logic = $ChompLogic

@onready var player_1_select = $CanvasLayer/Player1/Selection
@onready var player_2_select = $CanvasLayer/Player2/Selection

@onready var lost_panel = $CanvasLayer/LostPanel
@onready var lost_panel_text = $CanvasLayer/LostPanel/LostText
@onready var thinking_label = $CanvasLayer/Thinking

@onready var settings_panel = $CanvasLayer/PlaySettings
@onready var single_player = $CanvasLayer/PlaySettings/SinglePlayer
@onready var multi_player = $CanvasLayer/PlaySettings/MultiPlayer
@onready var you_label = $CanvasLayer/You

func _ready() -> void:
	thinking_label.visible = false
	lost_panel.visible = false
	player_2_select.visible = false
	
	chomp_logic.connect("game_over", Callable(self, "_on_game_over"))
	chomp_logic.connect("turn_changed", Callable(self, "_on_turn_changed"))
	chomp_logic.connect("ai_move", Callable(self, "_on_ai_move"))
	
func next_play():
	if player_num ==1:
		single_play()
	else:
		multi_play()

func single_play():
	set_current_player(1)
	you_label.show()
	var will_eat = calc_best_play()
	
	print("will eat", will_eat)
	thinking_label.visible = true
	choco_grid.can_move = false
	await get_tree().create_timer(2.0).timeout
	
	thinking_label.visible = false
	choco_grid.can_move = true
	set_current_player(2)
	choco_grid.eat_given_chunk(will_eat)
	print("single play")

func multi_play():
	print("current play", current_player)
	you_label.hide()
	if current_player == 1:
		set_current_player(2)
		current_player = 2
	else:
		set_current_player(1)
		current_player = 1
	
func _on_multi_player_pressed() -> void:
	player_num = 2
	start_game()

func _on_single_player_pressed() -> void:
	player_num = 1
	start_game()
	single_play()
	
func start_game():
	settings_panel.visible = false
	choco_grid.start_game = true
	return

func calc_best_play() -> Vector2:
	var deleted_points = choco_grid.deleted_points
	var added_point = choco_grid.just_added
	print("just added", added_point)
	var min_x = choco_grid.rows -1
	var min_y = choco_grid.cols -1
	if deleted_points.size() == 0:
		return Vector2(1.0, 1.0)
	else:
		return Vector2(added_point.y, added_point.x)
		
func end_game(you_won: bool):
	if player_num == 1:
		if you_won:
			lost_panel_text.text = "You won!!!"
		else:
			lost_panel_text.text = "You lost </3"
		lost_panel.visible = true
	else:
		lost_panel_text.text = "Player " + str(current_player)+ " lost"
		lost_panel.visible = true
		
func set_current_player(player: int):
	if player == 1:
		player_1_select.visible = true
		player_2_select.visible = false
	elif player == 2:
		player_1_select.visible = false
		player_2_select.visible = true

func _on_exit_pressed() -> void:
		SceneManager.show_scene("res://scripts+scenes/cafe/cafe.tscn")
