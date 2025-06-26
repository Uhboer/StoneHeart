extends Node
class_name Weapons



class Stick:
	func get_texture():
		pass
	func get_attack_cooldown():
		print("Nigga cooldown")
		Global.weapon_cd = 1
	func get_attack_range():
		Global.weapon_range = 1
		print("Nigga range")
	func get_damage():
		Global.damage_weapon = 10
		print("stick damage =", Global.damage_weapon)
	func deal_damage():
		print("stick deal damage")
