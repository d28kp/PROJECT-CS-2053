extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite = $AnimatedSprite2D
var facing_right = true

func _physics_process(delta):
	# 1. APPLY GRAVITY
	# If the player is in the air, apply the project's default gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. HANDLE JUMPING
	# Input names must match your Project -> Input Map settings
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. HANDLE HORIZONTAL MOVEMENT
	# get_axis returns -1 for left, 1 for right, and 0 for no input
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		# Update facing direction for animations
		facing_right = direction > 0
	else:
		# Gradually slow down when no direction is pressed
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. ANIMATION LOGIC
	# Determine which animation string should be active based on state
	var anim_to_play = ""

	if not is_on_floor():
		# Jumping/Falling state
		anim_to_play = "jumping_right" if facing_right else "jumping_left"
	elif direction == 0:
		# Idle/Standing state
		anim_to_play = "standing_right" if facing_right else "standing_left"
	else:
		# Walking/Running state
		anim_to_play = "running_right" if facing_right else "running_left"

	# ONLY call play() if the animation has actually changed.
	# This prevents the animation from "restarting" every frame, which causes flickering.
	if sprite.animation != anim_to_play:
		sprite.play(anim_to_play)

	# 5. EXECUTE MOVEMENT
	# move_and_slide uses the 'velocity' variable to move the character and handle collisions
	
	move_and_slide()
