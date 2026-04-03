extends RigidBody2D

func _ready():
	add_to_group("balls")
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = 0.8
	physics_material_override.friction = 0.0
	await get_tree().create_timer(8.0).timeout
	queue_free()

func launch_toward(target_pos: Vector2):
	var direction = (target_pos - global_position).normalized()
	var speed = randf_range(250, 450)
	linear_velocity = direction * speed

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage()
		queue_free()
