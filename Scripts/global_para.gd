extends Node

var seed = randi()

func _init() -> void:
	seed = randi()

func set_seed(s):
	seed = s
	
func get_seed():
	return seed
