extends Node

@export var duck_parent : Node2D

@export var big_duck : AnimatedSprite2D

@export var rock_duck : AnimatedSprite2D

@export var mother_duck : AnimatedSprite2D
@export var child_duck : AnimatedSprite2D

@export var cat_duck : AnimatedSprite2D

@export var wizard_duck : AnimatedSprite2D
@export var warp_timer : Timer

@export var toot_duck : AnimatedSprite2D
@export var toot_timer : Timer

@export var large_hitbox : CollisionShape2D
@export var small_hitbox : CollisionShape2D

var save_shortcut = Shortcut.new()

func swap_duck(duck) -> void:
	duck_parent.max_speed = duck.speed
	duck_parent.speed = duck.speed
	
	for child in duck_parent.get_children():
		if (child.is_class("AnimatedSprite2D")):
			child.visible = false

	match (duck.type):
		Duck.Type.BIG:
			duck_parent.sprite = big_duck
			large_hitbox.visible = true
			small_hitbox.visible = false
			
			big_duck.visible = true
		Duck.Type.ROCK:
			duck_parent.sprite = rock_duck
			small_hitbox.visible = true
			large_hitbox.visible = false
			
			rock_duck.visible = true
		Duck.Type.MOTHER:
			duck_parent.sprite = mother_duck
			small_hitbox.visible = true
			large_hitbox.visible = false
			
			mother_duck.visible = true
			child_duck.visible = true
		Duck.Type.CAT:
			duck_parent.sprite = cat_duck
			small_hitbox.visible = true
			large_hitbox.visible = false
			
			cat_duck.visible = true
		Duck.Type.WIZARD:
			duck_parent.sprite = wizard_duck
			small_hitbox.visible = true
			large_hitbox.visible = false
			
			wizard_duck.visible = true
		Duck.Type.TOOT:
			duck_parent.sprite = toot_duck
			small_hitbox.visible = true
			large_hitbox.visible = false
			
			toot_duck.visible = true
			
func _ready() -> void:
	var key_event = InputEventKey.new()
	key_event.keycode = KEY_I
	key_event.ctrl_pressed = true
	key_event.command_or_control_autoremap = true
	save_shortcut.events = [key_event]
	
	if (!DuckInfo.played_before):
		DuckInfo.played_before = true
		
		DuckInfo.current_duck = AllDucks.data["Tooter"]
		DuckInfo.current_place = 0
		swap_duck(DuckInfo.current_duck)

func _input(event):
	if save_shortcut.matches_event(event) and event.is_pressed() and not event.is_echo():
		DuckInfo.current_place += 1
		
		if (DuckInfo.current_place >= AllDucks.data.size()):
			DuckInfo.current_place = 0
			
		DuckInfo.current_duck = AllDucks.data.get(AllDucks.data.keys()[DuckInfo.current_place])
		if (DuckInfo.current_duck != AllDucks.data["Wizard"]):
			warp_timer.stop()
		if (DuckInfo.current_duck != AllDucks.data["Tooter"]):
			toot_timer.stop()
			duck_parent.finished_tooting = true
		
		duck_parent.speed = 0
		swap_duck(DuckInfo.current_duck)
