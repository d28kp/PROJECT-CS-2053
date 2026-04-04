extends Node2D

const TIME_LIMIT  = 30.0
const CLUE_TEXT   = "Code1 - SUII"

@export var ball_scene : PackedScene

var time_left = TIME_LIMIT
var spawning  = true

@onready var timer_label = $HUD/TIMER
@onready var clue_label  = $HUD/CLUE
@onready var lives_label = $HUD/LIVES
@onready var countdown_label = $HUD/Countdown
@onready var player      = $player

func _ready():
	clue_label.visible = false
	lives_label.text = "LIVES: ❤️❤️❤️"
	player.lives_changed.connect(_on_lives_changed)
	player.set_physics_process(false)
	$SpawnTimer.stop()
	_start_countdown()

func _start_countdown():
	# Show legend, count down from 3 then start
	countdown_label.visible = true
	countdown_label.text = "3"
	await get_tree().create_timer(1.0).timeout
	countdown_label.text = "2"
	await get_tree().create_timer(1.0).timeout
	countdown_label.text = "1"
	await get_tree().create_timer(1.0).timeout
	countdown_label.text = "GO!"
	await get_tree().create_timer(0.8).timeout
	countdown_label.visible = false
	# Hide legend and start game
	$HUD/Legend.visible = false
	player.set_physics_process(true)
	$SpawnTimer.start()
	spawning = true

func _fade_out_legend():
	await get_tree().create_timer(4.0).timeout
	var tween = create_tween()
	tween.tween_property($HUD/Legend, "modulate:a", 0.0, 1.5)
	await tween.finished
	$HUD/Legend.visible = false

func _on_lives_changed(new_lives):
	match new_lives:
		2: lives_label.text = "LIVES: ❤️❤️"
		1: lives_label.text = "LIVES: ❤️"
		0: lives_label.text = "LIVES: 💀"

func _process(delta):
	if not spawning:
		return
	time_left -= delta
	timer_label.text = "TIME: %d" % int(max(time_left, 0))
	# Flash timer red when under 10 seconds
	if time_left <= 10:
		timer_label.modulate = Color.RED
	if time_left <= 0:
		_level_complete()

func _on_spawn_timer_timeout():
	if not spawning:
		return
	var ball = ball_scene.instantiate()
	var edge = randi() % 3
	match edge:
		0: ball.position = Vector2(randf_range(50, 1230), -40)
		1: ball.position = Vector2(-40, randf_range(100, 680))
		2: ball.position = Vector2(1320, randf_range(100, 680))
	var aim = Vector2(640, 500) + Vector2(randf_range(-200, 200), randf_range(-100, 100))
	add_child(ball)
	ball.launch_toward(aim)

func _level_complete():
	spawning = false
	$SpawnTimer.stop()
	for ball in get_tree().get_nodes_in_group("balls"):
		ball.set_physics_process(false)
	clue_label.text = "DEFUSED! Code Fragment: 7\nIT GETS DIFFICULT FROM HERE!! YOU'RE ONTO THE NEXT LEVEL"
	clue_label.visible = true
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Level-2/level-2.tscn")
