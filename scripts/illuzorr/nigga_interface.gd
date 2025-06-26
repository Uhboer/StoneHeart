extends Node
class_name Interface

class Weapon:
	func get_texture():
		pass
	func get_attack_cooldown():
		pass
	func get_attack_range():
		pass
	func get_damage():
		pass
	func deal_damage():
		pass

class Ability:
	func get_cooldown():
		pass
	func can_use():
		pass
	func use():
		pass
