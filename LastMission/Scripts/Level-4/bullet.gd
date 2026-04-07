extends Area2D

@export var speed = 800

func _process(delta):
	position.y -= speed * delta

func _on_body_entered(body):
	if body.is_in_group("meteor"):
		body.queue_free()
		queue_free()
		get_tree().current_scene.meteor_destroyed()
