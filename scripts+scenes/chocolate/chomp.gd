extends Node

var rows := 4
var cols := 7
var board := [] #array of where chocolate squares are
var losing_pos := Vector2()

func init_board(r: int, c: int) -> void:
	rows = r
	cols = c
	board = []
	for i in range(rows):
		var row := []
		for j in range(cols):
			row.append(true)
		board.append(row)
		losing_pos = Vector2(rows - 1, cols - 1)
		
func in_bounds(r: int, c: int) -> bool:
	return r >= 0 and r < rows and c >= 0 and c < cols
	
func valid_moves() -> Array:
	var moves := []
	for r in range(rows):
		for c in range(cols):
			if board[r][c]:
				moves.append(Vector2(r, c))
	return moves
	
func apply_move(r: int, c: int) -> bool:
	if not in_bounds(r,c) || not board[r][c]:
		return false
	
	for rr in range(rows):
		for cc in range(cols):
			if board[rr][cc] and (rr <=r or cc>= c):
				board[rr][cc] = false
				
	return not board[losing_pos.x][losing_pos.y]
	
func is_game_over() -> bool:
	if not board[losing_pos.x][losing_pos.y]:
		return true
	for r in range(rows):
		for c in range(cols):
			if board[r][c]: return false
	return true
	
func serialize() -> String:
	var s := ""
	for r in range(rows):
		for c in range(cols):
			if board[r][c]:
				s+= "1"
	return s
	
func clone_board() -> Array:
	var nb := []
	for r in range(rows):
		nb.append(board[r].duplicate())
	return nb

func restore_board(saved: Array) -> void:
	board = []
	for row in saved:
		board.append(row.duplicate())

var memo := {}

func minimax_return_value() -> int:
	memo.clear()
	return _minimax(true)
	
func _minimax(player_turn: bool) -> int:
	var key := serialize()
	if key in memo:
		return memo[key]

	if not board[losing_pos.x][losing_pos.y]:
		memo[key] = +1
		return +1

	var moves := valid_moves()
	if moves.size() == 0:
		memo[key] = -1
		return -1

	for mv in moves:
		var saved := clone_board()
		var lost := apply_move(int(mv.x), int(mv.y))
		if lost:
			restore_board(saved)
			continue
		var val := _minimax(not player_turn)
		restore_board(saved)
		if val == -1:
			memo[key] = +1
			return +1

	memo[key] = -1
	return -1

func choose_best_move_minimax() -> Variant:
	var moves := valid_moves()
	if moves.size() == 0:
		return null
	var saved_global := clone_board()
	for mv in moves:
		var saved := clone_board()
		var lost := apply_move(int(mv.x), int(mv.y))
		if lost:
			restore_board(saved)
			continue
		var val := _minimax(false)
		restore_board(saved)
		if val == -1:
			return mv
	restore_board(saved_global)
	return moves[randi() % moves.size()]

func random_ai() -> Variant:
	var moves := valid_moves()
	if moves.size() == 0:
		return null
	return moves[randi() % moves.size()]
