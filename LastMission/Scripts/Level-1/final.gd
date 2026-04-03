extends Control
const CORRECT_CODE = "7A3XQ"

@onready var code_input    = $CodeInput
@onready var result_label  = $Result
@onready var clues_label   = $Code
@onready var submit_button = $Submit

func _ready():
	submit_button.pressed.connect(_on_submit_pressed)
	# Show collected clues from GameState
	# clues_label.text = "YOUR FRAGMENTS: " + " ".join(GameState.clues_collected)

func _on_submit_pressed():
	var entered = code_input.text.strip_edges().to_upper()
	if entered == CORRECT_CODE:
		_bomb_defused()
	else:
		_bomb_explodes()

func _bomb_defused():
	result_label.text = "✅ BOMB DEFUSED! THE WORLD IS SAVED!"
	result_label.modulate = Color(0, 1, 0)
	result_label.visible = true
	submit_button.disabled = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/EndScreen.tscn")

func _bomb_explodes():
	result_label.text = "💥 WRONG CODE — THE BOMB EXPLODED!"
	result_label.modulate = Color(1, 0, 0)
	result_label.visible = true
	await get_tree().create_timer(1.0).timeout
	result_label.visible = false
	code_input.text = ""
	# After 3 wrong attempts go back to menu
