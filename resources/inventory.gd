extends Control

var current_scene

@export var hotbar: HBoxContainer
@export var grid: GridContainer
@onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	current_scene = main

func _on_hotbar_equip(item: Item) -> void:
	if current_scene != null:
		current_scene.currently_equipped = item
		
func add_item(item: Item, amount: int =1):
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
