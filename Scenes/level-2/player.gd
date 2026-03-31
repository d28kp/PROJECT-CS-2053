extends CharacterBody2D

@export var speed: float = 200.0
var can_move := true

func _physics_process(delta):
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

func stop_movement():
	can_move = false
