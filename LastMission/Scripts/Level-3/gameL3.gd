extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var car_container: Node2D = $CarContainer
@onready var hud_label: Label = $HUD
@onready var start_marker: Marker2D = $StartMarker
@onready var map_node: Node2D = $Map
@onready var rules_popup: CanvasLayer = $RulesPopup

const SCREEN_WIDTH := 1280.0
const CAR_BODY_SIZE := Vector2(80.0, 28.0) 
const MAP_PIXEL_BLOCK := 6.0

const R1_LANE_TOP := 140.0    
const R1_LANE_BOTTOM := 204.0 

const R2_LANE_TOP := 340.0    
const R2_LANE_BOTTOM := 398.0 

const R3_LANE_TOP := 504.0    
const R3_LANE_BOTTOM := 560.0 

const CAR_COLORS := [Color(0.9, 0.2, 0.2), Color(0.2, 0.4, 0.9), Color(0.9, 0.7, 0.1), Color(0.1, 0.7, 0.3)]

const LANE_CONFIG := [
	{"y": R1_LANE_TOP, "speed": 210.0, "dir": -1.0, "gap": 2.5},
	{"y": R1_LANE_BOTTOM, "speed": 240.0, "dir": 1.0, "gap": 2.1},
	{"y": R2_LANE_TOP, "speed": 270.0, "dir": -1.0, "gap": 1.8},
	{"y": R2_LANE_BOTTOM, "speed": 310.0, "dir": 1.0, "gap": 1.5},
	{"y": R3_LANE_TOP, "speed": 180.0, "dir": -1.0, "gap": 2.8},
	{"y": R3_LANE_BOTTOM, "speed": 200.0, "dir": 1.0, "gap": 2.3}
]

var lane_timers: Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var score := 0
var car_textures: Array[Texture2D] = []
var map_pixel_material: ShaderMaterial
var game_started := false

func _ready() -> void:
	_build_map_pixel_material()
	_apply_map_pixel_style()
	_build_car_textures()
	player.position = start_marker.global_position
	player.set_physics_process(false)
	hud_label.text = "Press R to start"
	_show_rules_popup()

func _process(delta: float) -> void:
	if not game_started:
		return
	_handle_spawning(delta)
	_move_cars(delta)
	_check_win()

func _input(event: InputEvent) -> void:
	if game_started:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_start_game()

func _start_game() -> void:
	game_started = true
	player.set_physics_process(true)
	rules_popup.visible = false
	_update_hud()

func _handle_spawning(delta: float) -> void:
	var gap_multiplier = clamp(1.0 - (score * 0.0), 0.0, 1.0)
	
	for i in range(LANE_CONFIG.size()):
		lane_timers[i] -= delta
		if lane_timers[i] <= 0:
			var cfg = LANE_CONFIG[i]
			_create_car(cfg["y"], cfg["speed"], cfg["dir"])
			lane_timers[i] = (cfg["gap"] * gap_multiplier) + randf_range(-0.2, 0.2)

func _create_car(y: float, speed: float, dir: float) -> void:
	var car := Area2D.new()
	car.collision_layer = 2
	car.set_meta("speed", speed)
	car.set_meta("dir", dir)
	
	var sprite := Sprite2D.new()
	sprite.texture = car_textures[randi() % car_textures.size()]
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = Vector2(4, 4)
	sprite.flip_h = dir < 0
	car.add_child(sprite)
	
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = CAR_BODY_SIZE
	shape.shape = rect
	car.add_child(shape)
	
	car.body_entered.connect(func(body): 
		if body == player: 
			_handle_hit())
	
	car.position = Vector2(SCREEN_WIDTH + 150 if dir < 0 else -150, y)
	car_container.add_child(car)

func _build_car_textures() -> void:
	car_textures.clear()
	for base_color in CAR_COLORS:
		car_textures.append(_create_car_texture(base_color, 0))
		car_textures.append(_create_car_texture(base_color, 1))
		car_textures.append(_create_car_texture(base_color, 2))

func _create_car_texture(base_color: Color, style: int) -> ImageTexture:
	var image := Image.create(24, 12, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	
	var outline := base_color.darkened(0.4)
	var body := base_color
	var roof := base_color.lightened(0.2)
	var window := Color(0.72, 0.88, 1.0, 1.0)
	var front_light := Color(1.0, 0.95, 0.65, 1.0)
	var rear_light := Color(1.0, 0.35, 0.35, 1.0)
	var tire := Color(0.08, 0.08, 0.08, 1.0)
	var hub := Color(0.52, 0.52, 0.52, 1.0)
	
	match style:
		0:
			_fill_rect(image, Rect2i(2, 4, 20, 5), body)
			_fill_rect(image, Rect2i(7, 2, 10, 3), roof)
			_fill_rect(image, Rect2i(8, 3, 8, 1), window)
		1:
			_fill_rect(image, Rect2i(1, 5, 22, 4), body)
			_fill_rect(image, Rect2i(6, 3, 12, 3), roof)
			_fill_rect(image, Rect2i(7, 4, 10, 1), window)
		_:
			_fill_rect(image, Rect2i(2, 4, 20, 5), body)
			_fill_rect(image, Rect2i(9, 1, 7, 4), roof)
			_fill_rect(image, Rect2i(10, 2, 5, 2), window)
	
	_fill_rect(image, Rect2i(3, 9, 5, 2), tire)
	_fill_rect(image, Rect2i(16, 9, 5, 2), tire)
	_fill_rect(image, Rect2i(5, 9, 1, 2), hub)
	_fill_rect(image, Rect2i(18, 9, 1, 2), hub)
	
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			if image.get_pixel(x, y).a > 0.0 and _touches_transparent(image, x, y):
				image.set_pixel(x, y, outline)
	
	image.set_pixel(22, 6, front_light)
	image.set_pixel(22, 7, front_light)
	image.set_pixel(1, 6, rear_light)
	image.set_pixel(1, 7, rear_light)
	
	return ImageTexture.create_from_image(image)

func _fill_rect(image: Image, rect: Rect2i, color: Color) -> void:
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		for x in range(rect.position.x, rect.position.x + rect.size.x):
			image.set_pixel(x, y, color)

func _touches_transparent(image: Image, px: int, py: int) -> bool:
	for oy in range(-1, 2):
		for ox in range(-1, 2):
			if ox == 0 and oy == 0:
				continue
			var nx := px + ox
			var ny := py + oy
			if nx < 0 or ny < 0 or nx >= image.get_width() or ny >= image.get_height():
				return true
			if image.get_pixel(nx, ny).a == 0.0:
				return true
	return false

func _build_map_pixel_material() -> void:
	var shader := Shader.new()
	shader.code = """
shader_type canvas_item;
uniform float pixel_size = 6.0;
void fragment() {
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
	vec2 block_uv = floor(UV * tex_size / pixel_size) * pixel_size / tex_size;
	COLOR = texture(TEXTURE, block_uv) * COLOR;
}
"""
	map_pixel_material = ShaderMaterial.new()
	map_pixel_material.shader = shader
	map_pixel_material.set_shader_parameter("pixel_size", MAP_PIXEL_BLOCK)

func _apply_map_pixel_style() -> void:
	for child in map_node.get_children():
		if child is Sprite2D:
			var sprite := child as Sprite2D
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			sprite.material = map_pixel_material

func _move_cars(delta: float) -> void:
	var speed_multiplier = 1.0 + (score * 0.6)
	
	for car in car_container.get_children():
		var base_speed = car.get_meta("speed")
		var direction = car.get_meta("dir")
		
		car.position.x += direction * (base_speed * speed_multiplier) * delta
		
		if car.position.x < -250 or car.position.x > SCREEN_WIDTH + 250:
			car.queue_free()

func _check_win() -> void:
	if player.position.y <= 90.0:
		score += 1
		_reset_player()
		_update_hud()
		
		if score >= 5:
			hud_label.text = "3rd fragment: 3"
			set_process(false)
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://Scenes/Level-4/Level4.tscn")

func _handle_hit() -> void:
	score = max(0, score - 1)
	_reset_player()
	_update_hud()

func _reset_player() -> void:
	player.position = start_marker.global_position
	player.velocity = Vector2.ZERO

func _update_hud() -> void:
	hud_label.text = "Score: %d" % score

func _show_rules_popup() -> void:
	rules_popup.visible = true
