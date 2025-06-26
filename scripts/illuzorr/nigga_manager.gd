extends Node

var weapon


func _ready() -> void:
	test()
	pass

func test():
	weapon = NiggaSword.new()
	if "implements" in weapon:
		weapon.get_texture()
