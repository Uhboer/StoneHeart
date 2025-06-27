extends Node
var current_weapon: WeaponBase
var weapons = [WeaponBase]  
var current_weapon_index = 0

func attack():
	if current_weapon:
		current_weapon.attack()
