class_name Duck
extends Resource

enum Type {
	BIG,
	ROCK,
	MOTHER,
	CAT,
	WIZARD
}

@export var name: String
@export var type: Type
@export var speed: int

func _init(_name := "", _type := Type.BIG, _speed := 1200):
	name = _name
	type = _type
	speed = _speed
