extends CharacterBody2D

const SPEED    = 250.0
const JUMP_VEL = -520.0
const GRAVITY  = 980.0

var lives = 3
var spawn_pos : Vector2
var invincible = false

signal lives_changed(new_lives)

func _ready():
	spawn_pos = global_position
	add_to_group("player")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VEL
	var dir = Input.get_axis("ui_left", "ui_right")
	velocity.x = dir * SPEED
	
	if dir < 0:
		$AnimatedSprite2D.flip_h = true
	elif dir > 0:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif dir != 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	

func take_damage():
	if invincible:
		return
	lives -= 1
	emit_signal("lives_changed", lives)
	if lives <= 0:
		get_tree().change_scene_to_file("res://Scenes/Level-1/menu.tscn")
	else:
		_respawn()

func _respawn():
	invincible = true
	global_position = spawn_pos
	await get_tree().create_timer(1.5).timeout
	invincible = false
