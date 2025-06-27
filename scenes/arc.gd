extends Node2D

class_name Arc

@onready var attack = $attack
@onready var collision = $range/collision

var attacking = Global.attacking

func _process(delta):
	if attacking == false:
		look_at(get_global_mouse_position())
		collision.disabled = true
	if attacking:
		collision.disabled = false




func _on_range_body_entered(body):
	if body.name == "basemob" && attacking:
		print("collide")
		body.hp -= Global.damage_weapon
