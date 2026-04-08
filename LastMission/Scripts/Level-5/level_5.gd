extends Node2D

@onready var player = $PlayerL5
@onready var rules_popup = $RulesPopup
@onready var camera = $Camera2D
@onready var win_label = $WinLabel
var waiting_to_start := false
@onready var music = $BackgroundMusic

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
	if music.stream: 
		music.play(1.5)
	_show_rules()

func _show_rules():
	rules_popup.visible = true
	player.set_physics_process(false)
	waiting_to_start = true

func _unhandled_input(event):
	if waiting_to_start and event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		rules_popup.visible = false
		player.set_physics_process(true)
		waiting_to_start = false
