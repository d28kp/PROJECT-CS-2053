extends Control

func _ready():
	$MenuButton.pressed.connect(_on_menu_pressed)

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
