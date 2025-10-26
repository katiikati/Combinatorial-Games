extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.coins_label = self
	text = "Coins " + str(GameManager.coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
