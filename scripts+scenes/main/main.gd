extends Node2D


func _ready() -> void:
	print("SceneManager:", SceneManager)
	print("self:", self, " type:", typeof(self))
	print("get_tree().current_scene:", get_tree().get_current_scene())
	SceneManager.current_scene = self
	print("SceneManager.current_scene after set:", SceneManager.current_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
