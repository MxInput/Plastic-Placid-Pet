extends Node2D

var max_speed = 1600

var speed = max_speed
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

@export var child_sprite : AnimatedSprite2D

@export var warp_timer : Timer
const MAX_WARP_TIME := 30
const MIN_WARP_TIME := 5

func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
func _input(event):
	if event is InputEventMouseMotion:
		if (touching && !already_touched):
			already_touched = true
			direction = Vector2(clamp(event.relative.x, -1, 1), clamp(event.relative.y, -1, 1))
			
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
		
		match (index):
			0:
				if (DuckInfo.current_duck.type == Duck.Type.MOTHER):
					child_sprite.play("right")
				sprite.play("right")
			1:
				if (DuckInfo.current_duck.type == Duck.Type.MOTHER):
					child_sprite.play("down_right")
				sprite.play("down_right")
			2:
				if (DuckInfo.current_duck.type == Duck.Type.MOTHER):
					child_sprite.play("down")
				sprite.play("down")	
			3:
				if (DuckInfo.current_duck.type == Duck.Type.MOTHER):
					child_sprite.play("down_left")
				sprite.play("down_left")
			4:
				if (DuckInfo.current_duck.type == Duck.Type.MOTHER):
					child_sprite.play("left")
				sprite.play("left")
			5:
				if (DuckInfo.current_duck.type == Duck.Type.MOTHER):
					child_sprite.play("up_left")
				sprite.play("up_left")
			6:
				if (DuckInfo.current_duck.type == Duck.Type.MOTHER):
					child_sprite.play("up")
				sprite.play("up")
			7:
				if (DuckInfo.current_duck.type == Duck.Type.MOTHER):
					child_sprite.play("up_right")
				sprite.play("up_right")
		
	if (DuckInfo.current_duck.type == Duck.Type.MOTHER):
		if (direction != Vector2(0, 0)):
			child_sprite.position = Vector2(64 * direction.x, 64 * -direction.y)
		
	if (DuckInfo.current_duck.type == Duck.Type.WIZARD):
		if (warp_timer.is_stopped()):
			warp_timer.wait_time = randi_range(MIN_WARP_TIME, MAX_WARP_TIME)
			warp_timer.start()
			
	if (DuckInfo.current_duck.type == Duck.Type.CAT):
		var mouse_pos = get_local_mouse_position()
		direction = Vector2(clamp(mouse_pos.x, -1, 1), clamp(mouse_pos.y, -1, 1))
		decrement = 0
	
func _physics_process(delta: float) -> void:
	var window_pos = Vector2(DisplayServer.window_get_position())
	window_pos += direction * speed * delta

	window_pos.x = clamp(window_pos.x, 0, screen_size.x - window_size.x)
	window_pos.y = clamp(window_pos.y, 0, screen_size.y - window_size.y)
	
	DisplayServer.window_set_position(Vector2i(window_pos))
	
	if window_pos.x <= 0 or window_pos.x >= screen_size.x - window_size.x:
		speed = max_speed
		
		if (since_last_stopped < TIME_CHECK):
			decrement = INITIAL_DEC
		
		direction.x *= -1
	if window_pos.y <= 0 or window_pos.y >= screen_size.y - window_size.y:
		speed = max_speed
		
		if (since_last_stopped < TIME_CHECK):
			decrement = INITIAL_DEC
		
		direction.y *= -1	

func _on_area_2d_mouse_entered() -> void:
	speed = max_speed
	
	if (since_last_stopped < TIME_CHECK):
		decrement = INITIAL_DEC
	
	touching = true
	
func _on_area_2d_mouse_exited() -> void:
	already_touched = false
	touching = false

func _on_warp_timer_timeout() -> void:
	if (duck)
	pass # Replace with function body.
