extends Control

func _ready():
	$LEVEL1.pressed.connect(_on_level_1_pressed)
	$LEVEL2.pressed.connect(_on_level_2_pressed)
	$LEVEL3.pressed.connect(_on_level_3_pressed)
	$LEVEL4.pressed.connect(_on_level_4_pressed)
	$LEVEL5.pressed.connect(_on_level_5_pressed)

	_update_buttons()

func _update_buttons():
	$LEVEL2.disabled = not ProgressData.level_1_completed
	$LEVEL3.disabled = not ProgressData.level_2_completed
	$LEVEL4.disabled = not ProgressData.level_3_completed
	$LEVEL5.disabled = not ProgressData.level_4_completed

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level-1/level_1.tscn")

func _on_level_2_pressed():
	if ProgressData.level_2_unlocked:
		get_tree().change_scene_to_file("res://Scenes/Level-2/level-2.tscn")
	else:
		ProgressData.next_level_to_open = 2
		get_tree().change_scene_to_file("res://Scenes/code_input.tscn")

func _on_level_3_pressed():
	if ProgressData.level_3_unlocked:
		get_tree().change_scene_to_file("res://Scenes/Level-3/level-3.tscn")
	else:
		ProgressData.next_level_to_open = 3
		get_tree().change_scene_to_file("res://Scenes/code_input.tscn")

func _on_level_4_pressed():
	if ProgressData.level_4_unlocked:
		get_tree().change_scene_to_file("res://Scenes/Level-4/Level4.tscn")
	else:
		ProgressData.next_level_to_open = 4
		get_tree().change_scene_to_file("res://Scenes/code_input.tscn")

func _on_level_5_pressed():
	if ProgressData.level_5_unlocked:
		get_tree().change_scene_to_file("res://Scenes/Level-5/level_5.tscn")
	else:
		ProgressData.next_level_to_open = 5
		get_tree().change_scene_to_file("res://Scenes/code_input.tscn")
