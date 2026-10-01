extends Node2D

const MAX_SPEED = 300

var speed = 300
var direction = Vector2(1, 0)

var screen_size = Vector2()
var window_size = Vector2(200, 200)

var touching = false
var already_touched = false

const INITIAL_DEC = 0.4
const DECREMENT_INC = 0.3

var decrement = 0.4

const TIME_CHECK = 10
var since_last_stopped = 0

@export var sprite : AnimatedSprite2D

func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
func _input(event):
	if event is InputEventMouseMotion:
		if (touching && !already_touched):
			already_touched = true
			direction = event.relative
			
func _process(delta: float) -> void:
	if (speed != 0):
		since_last_stopped += delta
	else:
		since_last_stopped = 0
	
	decrement += delta * (DECREMENT_INC + DECREMENT_INC)
	
	if (speed > 0):
		speed -= decrement
		
		if (speed <= 0):
			since_last_stopped = 0
			
			speed = 0
			
	if not direction.is_zero_approx():
		var angle = direction.angle()
		var offset = angle / (PI/4)
		var index = wrapi(int(offset), 0, 8)
				
		print(direction, " ", angle)
		
		match (index):
			0:
				sprite.play("right")
			1:
				sprite.play("down_right")
			2:
				sprite.play("down")	
			3:
				sprite.play("down_left")
			4:
				sprite.play("left")
			5:
				sprite.play("up_left")
			6:
				sprite.play("up")
			7:
				sprite.play("up_right")
			
	
func _physics_process(delta: float) -> void:
	var window_pos = Vector2(DisplayServer.window_get_position())
	window_pos += direction * speed * delta

	window_pos.x = clamp(window_pos.x, 0, screen_size.x - window_size.x)
	window_pos.y = clamp(window_pos.y, 0, screen_size.y - window_size.y)
	
	DisplayServer.window_set_position(Vector2i(window_pos))
	
	if window_pos.x <= 0 or window_pos.x >= screen_size.x - window_size.x:
		speed = MAX_SPEED
		
		if (since_last_stopped < TIME_CHECK):
			decrement = INITIAL_DEC
		
		direction.x *= -1
	if window_pos.y <= 0 or window_pos.y >= screen_size.y - window_size.y:
		speed = MAX_SPEED
		
		if (since_last_stopped < TIME_CHECK):
			decrement = INITIAL_DEC
		
		direction.y *= -1	

func _on_area_2d_mouse_entered() -> void:
	speed = MAX_SPEED
	
	if (since_last_stopped < TIME_CHECK):
		decrement = INITIAL_DEC
	
	touching = true
	
func _on_area_2d_mouse_exited() -> void:
	already_touched = false
	touching = false
