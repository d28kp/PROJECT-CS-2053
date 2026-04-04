extends Node2D

@onready var player = $Player
@onready var goal = $Goal
@onready var danger = $Danger
@onready var timer_label = $Msg/TimerLabel
@onready var story_popup = $CanvasLayerUI/StoryPopup
@onready var win_popup = $CanvasLayerUI/WinPopup
@onready var overlay = $CanvasLayerUI/ColorRect
@onready var music = $BackgroundMusic

var game_over := false
var game_started := false
var time_left := 120.0

func _ready():
	game_over = false
	game_started = false
	time_left = 120.0

	timer_label.text = "Time Left: 2:00"
	win_popup.hide()
	story_popup.show()
	overlay.show()

	player.set_process(false)
	player.set_physics_process(false)

	goal.body_entered.connect(_on_goal_body_entered)
	danger.body_entered.connect(_on_danger_body_entered)

func _process(delta):
	if game_started and not game_over:
		time_left -= delta

		if time_left < 0:
			time_left = 0

		update_timer_label()

		if time_left <= 0:
			get_tree().reload_current_scene()

	if game_over and Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

func update_timer_label():
	var total_seconds = int(ceil(time_left))
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	timer_label.text = "Time Left: %d:%02d" % [minutes, seconds]

func _on_button_pressed():
	story_popup.hide()
	overlay.hide()
	game_started = true
	player.set_process(true)
	player.set_physics_process(true)

func _on_goal_body_entered(body):
	if body == player and game_started and not game_over:
		game_over = true
		player.set_process(false)
		player.set_physics_process(false)
		win_popup.show()

func _on_danger_body_entered(body):
	if body == player and game_started and not game_over:
		game_over = true
		player.set_process(false)
		player.set_physics_process(false)
		get_tree().reload_current_scene()

func _on_win_button_pressed():
	music.stop()
	get_tree().change_scene_to_file("res://Scenes/Level-3/level-3.tscn")
