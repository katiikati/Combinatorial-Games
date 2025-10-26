extends Control

var current_player = 1
var player_num = 1

@onready var audio_player = $AudioStreamPlayer

@onready var choco_grid = get_tree().get_first_node_in_group("choco-grid")
@onready var chomp_logic = $ChompLogic

@onready var player_1_select = $CanvasLayer/Player1/Selection
@onready var player_2_select = $CanvasLayer/Player2/Selection

var current_player_select = 1

@onready var lost_panel = $CanvasLayer/LostPanel
@onready var lost_panel_text = $CanvasLayer/LostPanel/LostText
@onready var thinking_label = $CanvasLayer/Thinking

@onready var settings_panel = $CanvasLayer/PlaySettings
@onready var single_player = $CanvasLayer/PlaySettings/VBox/SinglePlayer
@onready var multi_player = $CanvasLayer/PlaySettings/VBox/MultiPlayer
@onready var you_label = $CanvasLayer/You

var pink_box: StyleBox = load("res://themes/pink_round.tres")
var dark_pink_box: StyleBox = load("res://themes/dark_pink_round.tres")

func _ready() -> void:
	thinking_label.visible = false
	lost_panel.visible = false
	player_2_select.visible = false
	
func _process(delta: float) -> void:
	if settings_panel.visible:
		if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("down"):
			print(single_player.get_class())
			if current_player_select == 1:
				print("switch to 2")
				current_player_select = 2
				single_player.add_theme_stylebox_override("normal", pink_box)
				multi_player.add_theme_stylebox_override("normal", dark_pink_box)
			elif current_player_select == 2:
				print("switch to 1")
				current_player_select = 1
				single_player.add_theme_stylebox_override("normal", dark_pink_box)
				multi_player.add_theme_stylebox_override("normal", pink_box)
				
		if Input.is_action_just_pressed("ui_accept"):
			accept_player_num()
	
func accept_player_num():
	audio_player.play()
	player_num = current_player_select
	if player_num ==1:
		chomp_logic.init_board(4,4)
		single_play()
	else:
		multi_play()
	start_game()
			
func next_play():
	if player_num ==1:
		single_play()
	else:
		multi_play()

func single_play():
	player_num = 1
	start_game()
	var will_eat = chomp_logic.choose_best_move_minimax()
	
	print("will eat", will_eat)
	thinking_label.visible = true
	choco_grid.can_move = false
	await get_tree().create_timer(2.0).timeout
	
	thinking_label.visible = false
	choco_grid.can_move = true
	set_current_player(2)
	choco_grid.eat_given_chunk(will_eat)
	chomp_logic.apply_move(will_eat.x, will_eat.y)
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
	
func start_game():
	settings_panel.visible = false
	choco_grid.start_game = true
	return
		
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

func _on_multi_player_pressed() -> void:
	current_player_select = 2
	accept_player_num()

func _on_single_player_pressed() -> void:
	current_player_select = 1
	accept_player_num()
