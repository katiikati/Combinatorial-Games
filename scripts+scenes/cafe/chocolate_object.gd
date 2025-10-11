extends StaticBody2D

@onready var interact_icon = $InteractIcon

func _ready():
	interact_icon.visible = false

func _on_actionable_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	interact_icon.visible = true

func _on_actionable_body_exited(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	interact_icon.visible = false
