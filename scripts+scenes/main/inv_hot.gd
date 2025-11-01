extends Control

@onready var hotbar: Control = $Hotbar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item(item: Item, amount: int = 1):
	print(item.title)
	for slot in hotbar.get_children():
		if slot.item == null:
			slot.item = item
			slot.set_amount(amount)
			hotbar.update()
			return
		elif slot.item == item:
			slot.add_amount(1)
			hotbar.update()
			return
			
func clear():
	for slot in hotbar.get_shildren():
		if slot.item != null && slot.item.title != "default":
			slot.item = null
	hotbar.index = 0


func _on_h_box_container_mouse_entered() -> void:
	print("asfdsasdf")
