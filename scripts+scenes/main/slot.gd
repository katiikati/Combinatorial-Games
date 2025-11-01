extends Control

@export var icon_texture: Texture2D
@onready var icon = $Icon

@export var item: Item = null:
	set(value):
		print("Setting item to:", value)
		item = value
		
		if value == null:
			$Icon.texture = null
			$Amount.text = ""
			return
			
		$Icon.texture = value.icon

@export var amount: int = 0:
	set(value):
		amount = value
		$Amount.text = str(value)
		if amount <=0:
			item = null
			
func _ready():
	if item:
		print("item", item)
		icon.texture = item.icon
		$Amount.text = str(amount)
			
func set_amount(value: int):
	amount = value
	
func add_amount(value: int):
	amount += value
	
func _get_drag_data(at_position):
	print("drag")
	#if not icon.texture:
	#	return null
	var preview = TextureRect.new()
	preview.texture = icon.texture 
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	set_drag_preview(preview)
	return icon.texture

func _can_drop_data(at_position, data):
	print("can_drop", data)
	return data is Texture2D
	
func _drop_data(at_position, data):
	print("dropped", data)
	icon.texture = data

func _on_icon_mouse_entered() -> void:
	print("connected mouse to slot")
	
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left click pressed on slot")
	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		print("Mouse motion with left held")
