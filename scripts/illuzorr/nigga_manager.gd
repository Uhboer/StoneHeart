extends Node

var weapon

func _ready() -> void:
	# test()
	pass

func test():
	weapon = NiggaSword.new()
	
	if "implements" not in weapon:
		return
	if weapon.implements != Interface.Weapon:
		return
	
	# Logic with our weapon
	weapon.get_texture()
	if "implements" in weapon:
		weapon.get_texture()
