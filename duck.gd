class_name Duck
extends Resource

enum Type {
	BIG,
	ROCK	
}

@export var name: String
@export var type: Type

func _init(_name := "", _type := Type.BIG):
	name = _name
	type = _type
