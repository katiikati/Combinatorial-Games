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
	if not in_bounds(r,c):
		pass
