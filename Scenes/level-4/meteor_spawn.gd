extends Node2D

@export var meteor_scene: PackedScene

var total_to_spawn = 12
var spawned = 0

func start_spawning():
	spawn_wave()

func spawn_wave():
	if spawned >= total_to_spawn:
		return
	
	for i in range(2):
		if spawned < total_to_spawn:
			spawn_meteor()
			spawned += 1
	
	await get_tree().create_timer(5).timeout
	spawn_wave()

func spawn_meteor():
	var meteor = meteor_scene.instantiate()
	var screen_size = get_viewport_rect().size
	var margin = 50
	var meteor_center_offset = Vector2(893, 130)
	var spawn_center = Vector2(
		randf_range(screen_size.x * 0.7, screen_size.x - margin),
		randf_range(margin, screen_size.y * 0.25)
	)
	meteor.position = spawn_center - meteor_center_offset
	add_child(meteor)
