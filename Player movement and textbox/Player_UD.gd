extends KinematicBody2D

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const GRAVITY = -500
const JUMP_FORCE = -128
const AIR_RESISTANCE = 0.02

var motion = Vector2.ZERO

onready var sprite = $Sprite

func _physics_process(delta):
	var x_input = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	
	if x_input!=0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input<0
	

	
#	applies gravity
	motion.y += GRAVITY * delta
	
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
			
		if Input.is_action_just_pressed('ui_down'):
			motion.y = -JUMP_FORCE
			
	else:
		if Input.is_action_just_released('ui_down') and motion.y > -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
	
#	moves player
	motion = move_and_slide(motion, Vector2.DOWN)
