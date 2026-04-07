extends Control

@onready var code_edit = $LineEdit
@onready var submit_button = $SubmitButton
@onready var message_label = $MessageLabel
@onready var enter_code_label = $EnterCodeLabel

func _ready():
	message_label.text = ""
	submit_button.pressed.connect(_on_submit_pressed)

	match ProgressData.next_level_to_open:
		2:
			enter_code_label.text = "Enter Code Fragment for Level 2"
		3:
			enter_code_label.text = "Enter Code Fragment for Level 3"
		4:
			enter_code_label.text = "Enter Code Fragment for Level 4"
		5:
			enter_code_label.text = "Enter Code Fragment for Level 5"

func _on_submit_pressed():
	var typed_code = code_edit.text

	match ProgressData.next_level_to_open:
		2:
			if typed_code == ProgressData.level_1_code:
				ProgressData.level_2_unlocked = true
				get_tree().change_scene_to_file("res://Scenes/Level-2/level-2.tscn")
			else:
				message_label.text = "Wrong code. Try again."

		3:
			if typed_code == ProgressData.level_2_code:
				ProgressData.level_3_unlocked = true
				get_tree().change_scene_to_file("res://Scenes/Level-3/level-3.tscn")
			else:
				message_label.text = "Wrong code. Try again."

		4:
			if typed_code == ProgressData.level_3_code:
				ProgressData.level_4_unlocked = true
				get_tree().change_scene_to_file("res://Scenes/Level-4/Level4.tscn")
			else:
				message_label.text = "Wrong code. Try again."

		5:
			if typed_code == ProgressData.level_4_code:
				ProgressData.level_5_unlocked = true
				get_tree().change_scene_to_file("res://Scenes/Level-5/level_5.tscn")
			else:
				message_label.text = "Wrong code. Try again."
