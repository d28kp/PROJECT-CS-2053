extends CharacterBody2D

@export var speed = 300

var magazine_size = 7
var bullets_left = 7
var shoot_cooldown = 2.0
var reload_time = 10.0
var reload_time_remaining = 0.0

var can_shoot = true
var reloading = false

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	velocity = direction.normalized() * speed
	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	var offset = Vector2(124, 128)
	var radius = 87.0
	var min_pos = Vector2(radius - offset.x, radius - offset.y)
	var max_pos = Vector2(screen_size.x - offset.x - radius, screen_size.y - offset.y - radius)
	position.x = clampf(position.x, min_pos.x, max_pos.x)
	position.y = clampf(position.y, min_pos.y, max_pos.y)
	
	check_collision()

func _process(delta):
	if reloading:
		reload_time_remaining = max(reload_time_remaining - delta, 0.0)
	get_tree().current_scene.update_ammo_ui(bullets_left, reloading, reload_time_remaining)
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	if not can_shoot or reloading:
		return
	
	if bullets_left <= 0:
		reload()
		return
	
	bullets_left -= 1
	
	var bullet = preload("res://Bullet.tscn").instantiate()
	bullet.global_position = $Marker2D.global_position
	
	get_tree().current_scene.add_child(bullet)
	
	can_shoot = false
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true
	
	if bullets_left == 0:
		reload()

func reload():
	reloading = true
	reload_time_remaining = reload_time 
	await get_tree().create_timer(reload_time).timeout
	bullets_left = magazine_size
	reloading = false

func die():
	hide()
	set_physics_process(false)
	set_process(false)
	get_tree().current_scene.game_over("You got hit!")

func check_collision():
	for i in range(get_slide_collision_count()):
		var coll = get_slide_collision(i)
		var body = coll.get_collider()
		if body.is_in_group("meteor"):
			die()
