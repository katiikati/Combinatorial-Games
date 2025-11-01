extends Label

var fade_times := 100
var faded := 0

func _ready():
	start_fade()

func start_fade():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.5, 1.0)
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	tween.finished.connect(_on_fade_done)

func _on_fade_done():
	faded += 1
	if faded < fade_times:
		start_fade()
