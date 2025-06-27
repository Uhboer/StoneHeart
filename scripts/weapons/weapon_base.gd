extends Node
class_name WeaponBase


@export var damage = 10
@export var attack_cooldown = 0.5
@export var range = 1


var can_attack = true

func attack():
	if can_attack:
		can_attack = false
		Global.attacking = true
		await get_tree().create_timer(0.5).timeout
		Global.attacking = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
