extends Node

var weapon

var _shop : NiggaShop

func _ready() -> void:
	# test()
	_shop = NiggaShop.new()
	pass

func test():
	weapon = NiggaSword.new()
	
	if "implements" not in weapon:
		return
	if weapon.implements != Interface.Weapon:
		return
	
	# Logic with our weapon
	weapon.get_texture()
