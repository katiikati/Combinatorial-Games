@tool
extends BTAction

@export var chomp_path: NodePath
@export var fallback_to_minimax := true

var chomp: Node = null

func _setup() -> void:
	chomp = scene_root.get_node_or_null(chomp_path)

func _tick(delta: float) -> Status:
	if not is_instance_valid(chomp):
		chomp = scene_root.get_node_or_null(chomp_path)
		if not is_instance_valid(chomp):
			return FAILURE

	var mv: Variant = null

	# fallback to minimax
	if fallback_to_minimax and chomp.has_method("choose_best_move_minimax"):
		mv = chomp.choose_best_move_minimax()

	# last resort: random
	if mv == null and chomp.has_method("random_ai"):
		mv = chomp.random_ai()

	if mv != null:
		chomp.apply_move(int(mv.x), int(mv.y))
		return SUCCESS

	return FAILURE
