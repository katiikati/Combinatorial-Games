extends Control

@export var slot_count := 9
@onready var slots := $HBoxContainer.get_children()
var selected_index := 0

func _ready() -> void:
	select_slot(0)

func select_slot(index):
	for i in range(slots.size()):
		var highlight = slots[i].get_node("Highlight")
		highlight.visible = (i == index)
	selected_index = index
	
func _unhandled_input(event):
	#switched selected on 1-5
	if event is InputEventKey and event.pressed:
		var num := int(event.as_text()) - 1
		if num >= 0 and num < slots.size():
			select_slot(num)
			
