extends CharacterBody2D

@export var speed := 200.0
@export var screen_limit := Vector2(1280, 720)

func _physics_process(_delta: float) -> void:
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input * speed
	move_and_slide()
	
	position.x = clamp(position.x, 25, screen_limit.x - 25)
	position.y = clamp(position.y, 25, screen_limit.y - 25)

func is_in_safe_zone() -> bool:
	var y = position.y
	if y <= 130.0: 
		return true  
	if y >= 228.0 and y <= 325.0: 
		return true
	if y >= 424.0 and y <= 515.0: 
		return true 
	if y >= 620.0: 
		return true               
	return false
