extends Control

func _ready():
	$LEVEL1.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://level_1.tscn")
