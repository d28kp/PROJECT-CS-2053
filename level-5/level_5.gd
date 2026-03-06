extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D
@onready var win_label = $WinLabel

func _on_fall_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().reload_current_scene()

func _on_goal_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		win_label.visible = true
		player.set_physics_process(false)
