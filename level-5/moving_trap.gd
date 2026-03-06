extends CharacterBody2D

@onready var point_a = $PointA
@onready var point_b = $PointB

var speed = 120
var target
var rotation_speed = 6

func _ready():
	target = point_b.global_position

func _physics_process(_delta):

	var direction = (target - global_position).normalized()
	velocity = direction * speed

	move_and_slide()
	rotation += rotation_speed * _delta
	# If we reached the target, switch direction
	if global_position.distance_to(target) < 5:
		if target == point_b.global_position:
			target = point_a.global_position
		else:
			target = point_b.global_position


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().reload_current_scene()
