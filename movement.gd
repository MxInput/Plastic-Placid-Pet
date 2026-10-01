extends Node2D

const MAX_SPEED = 300

var speed = 300
var direction = Vector2(1, 0)

var screen_size = Vector2()
var window_size = Vector2(200, 200)

var touching = false
var already_touched = false

const INITIAL_DEC = 0.4
const DECREMENT_INC = 0.5

var decrement = 0.4

func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
func _input(event):
	if event is InputEventMouseMotion:
		if (touching):
			already_touched = true
			direction = event.relative
			
func _process(delta: float) -> void:
	decrement += delta * DECREMENT_INC
	print(speed)
	if (speed > 0):
		speed -= decrement
		
		if (speed <= 0):
			speed = 0
	
func _physics_process(delta: float) -> void:
	var window_pos = Vector2(DisplayServer.window_get_position())
	window_pos += direction * speed * delta

	window_pos.x = clamp(window_pos.x, 0, screen_size.x - window_size.x)
	window_pos.y = clamp(window_pos.y, 0, screen_size.y - window_size.y)
	
	DisplayServer.window_set_position(Vector2i(window_pos))
	
	if window_pos.x <= 0 or window_pos.x >= screen_size.x - window_size.x:
		speed = MAX_SPEED
		decrement = INITIAL_DEC
		
		direction.x *= -1
	if window_pos.y <= 0 or window_pos.y >= screen_size.y - window_size.y:
		speed = MAX_SPEED
		decrement = INITIAL_DEC
		
		direction.y *= -1	

func _on_area_2d_mouse_entered() -> void:
	speed = MAX_SPEED
	decrement = INITIAL_DEC
	
	touching = true
	
func _on_area_2d_mouse_exited() -> void:
	already_touched = false
	touching = false
