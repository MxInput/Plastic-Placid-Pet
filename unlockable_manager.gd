extends Node

var current_duck : Duck
var played_before := false

func _ready() -> void:
	if (!played_before):
		played_before = true
		
		current_duck = AllDucks.data["Rock"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
