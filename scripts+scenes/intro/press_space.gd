extends Label


func _ready() -> void:
	fade_loop()

func fade_loop():
	var tween = get_tree().create_tween()
	tween.set_loops(0) 
	tween.tween_property(self, "modulate:a", 0.5, 1.0) 
	tween.tween_property(self, "modulate:a", 1.0, 1.5)
