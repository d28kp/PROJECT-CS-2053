extends Node2D

@onready var player = $PlayerL5
@onready var rules_popup = $RulesPopup
@onready var camera = $Camera2D
@onready var win_label = $WinLabel


func _on_fall_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().reload_current_scene()

func _on_goal_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		win_label.visible = true
		player.set_physics_process(false)
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Scenes/Level-1/FINAL.tscn")
	
func _ready():
	_show_rules()

func _show_rules():
	rules_popup.visible = true
	player.set_physics_process(false)
	await get_tree().create_timer(3.0).timeout
	rules_popup.visible = false
	player.set_physics_process(true)
