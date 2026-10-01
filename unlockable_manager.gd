extends Node

@export var duck_parent : Node2D

@export var big_duck : AnimatedSprite2D
@export var rock_duck : AnimatedSprite2D

@export var large_hitbox : CollisionShape2D
@export var small_hitbox : CollisionShape2D

func swap_duck(duck) -> void:
	duck_parent.max_speed = duck.speed
	
	for child in duck_parent.get_children():
		if (!child.is_class("Node")):
			child.visible = false

	match (duck.type):
		Duck.Type.BIG:
			duck_parent.sprite = big_duck
			large_hitbox.visible = true
			
			big_duck.visible = true
		Duck.Type.ROCK:
			duck_parent.sprite = rock_duck
			small_hitbox.visible = true
			
			rock_duck.visible = true
			
func _ready() -> void:
	if (!DuckInfo.played_before):
		DuckInfo.played_before = true
		
		DuckInfo.current_duck = AllDucks.data["Rock"]
		swap_duck(DuckInfo.current_duck)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
