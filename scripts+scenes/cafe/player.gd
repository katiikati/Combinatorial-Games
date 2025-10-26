extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0

@onready var actionable_finder = $ActionableFinder
@onready var anim_sprite = $AnimatedSprite2D

var in_dialogue = false
var last_dir = Vector2(0,1)

func _ready():
	GameManager.player = self

func _physics_process(delta: float) -> void:
	if DialogueManager.in_dialogue:
		return

	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		for actionable in actionables:
				if actionable.has_method("action"):
					print("has action")
					actionable.action()
					
	if in_dialogue:
		velocity = Vector2.ZERO
		return

	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * SPEED
		if velocity.x > 0:
			anim_sprite.play("right_walk")
			last_dir = Vector2(1,0)
		elif velocity.x < 0:
			anim_sprite.play("left_walk")
			last_dir = Vector2(-1,0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var direction_y := Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * SPEED
		if !direction_x:
			anim_sprite.play("front_walk")
		last_dir = Vector2(0,1)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if velocity.length() ==0:
		if last_dir == Vector2(1,0):
			anim_sprite.play("right_default")
		elif last_dir == Vector2(-1,0):
			anim_sprite.play("left_default")
		else:
			anim_sprite.play("default")
		
	velocity = velocity.normalized() * SPEED
	move_and_slide()
	
