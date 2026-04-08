extends CharacterBody2D

@export var speed = 200
var direction = Vector2.ZERO
const CENTER_OFFSET = Vector2(893, 130)
const MIN_DIRECTION_COMPONENT = 0.4
const BOUNCE_NUDGE = 8.0

func _ready():
	var dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if abs(dir.x) < MIN_DIRECTION_COMPONENT:
		dir.x = MIN_DIRECTION_COMPONENT * (1 if randf() > 0.5 else -1)
	if abs(dir.y) < MIN_DIRECTION_COMPONENT:
		dir.y = MIN_DIRECTION_COMPONENT * (1 if randf() > 0.5 else -1)
	direction = dir.normalized()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	var center = global_position + CENTER_OFFSET
	var screen_size = get_viewport_rect().size
	var margin = 90
	if center.x <= margin and direction.x < 0:
		direction.x *= -1
		position.x += BOUNCE_NUDGE
	elif center.x >= screen_size.x - margin and direction.x > 0:
		direction.x *= -1
		position.x -= BOUNCE_NUDGE
	if center.y <= margin and direction.y < 0:
		direction.y *= -1
		position.y += BOUNCE_NUDGE
	elif center.y >= screen_size.y - margin and direction.y > 0:
		direction.y *= -1
		position.y -= BOUNCE_NUDGE
