extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0

@onready var actionable_finder = $ActionableFinder
@onready var anim_sprite = $AnimatedSprite2D

var in_dialogue = false

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		for actionable in actionables:
				if actionable.has_method("action"):
					actionable.action()
					
	if in_dialogue:
		velocity = Vector2.ZERO
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * SPEED
		anim_sprite.play("side_walk")
		anim_sprite.scale =Vector2(0.9,0.9)
		if(direction_x < 0):
			anim_sprite.flip_h = true
		else:
			anim_sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var direction_y := Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * SPEED
		anim_sprite.play("front_walk")
		anim_sprite.scale =Vector2(1,1)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if velocity.length() ==0:
		anim_sprite.play("default")
		anim_sprite.scale = Vector2(1,1)
		
	velocity = velocity.normalized() * SPEED
	move_and_slide()
	
