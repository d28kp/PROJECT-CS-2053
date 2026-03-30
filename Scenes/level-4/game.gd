extends Node2D

var time_left = 90
var meteors_destroyed = 0
var total_meteors = 12
var game_started = false

func _ready():
	$UI/StartLabel.text = _get_start_text()
	$UI/StartLabel.show()
	$UI/Msg.hide()
	$UI/Timer.hide()
	$UI/Ammo.hide()
	$UI/Reload.hide()
	get_tree().paused = true

func _get_start_text() -> String:
	var player = $Player
	return """GET READY!

Time limit: %d seconds
Meteors to destroy: %d
Bullets per magazine: %d
Time between shots: %.1f seconds
Reload time: %.1f seconds

Press F to Start""" % [time_left, total_meteors, player.magazine_size, player.shoot_cooldown, player.reload_time]

func start_game():
	if game_started:
		return
	game_started = true
	$UI/StartLabel.hide()
	$UI/Timer.show()
	$UI/Ammo.show()
	update_ui()
	$Timer.start()
	$MeteorSpawn.start_spawning()
	get_tree().paused = false

func meteor_destroyed():
	meteors_destroyed += 1
	
	if meteors_destroyed >= total_meteors:
		victory()

func game_over(msg):
	$UI/Msg.text = msg + "\nPress R to Restart"
	$UI/Msg.show()
	$UI/Timer.hide()
	$UI/Ammo.hide()
	get_tree().paused = true

func victory():
	$UI/Msg.text = "YOU WIN!\n"
	$UI/Msg.show()
	$UI/Timer.hide()
	$UI/Ammo.hide()
	$UI/Reload.hide()
	get_tree().paused = true

func update_ui():
	$UI/Timer.text = "Time: " + str(time_left)

func _input(event):
	if not game_started:
		if Input.is_action_just_pressed("Start"):
			start_game()
		return
	if Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	time_left -= 1
	update_ui()
	if time_left <= 0:
		game_over("Time's up!")

func update_ammo_ui(bullets: int, is_reloading: bool, time_remaining: float):
	$UI/Ammo.text = "Bullets: " + str(bullets)
	if is_reloading:
		$UI/Reload.text = "Reloading... %.1fs" % time_remaining
		$UI/Reload.show()
	else:
		$UI/Reload.hide()
