extends Node2D

@onready var attack = $attack
@onready var collision = $range/collision


func _process(delta):
	if Global.attacking == false:
		look_at(get_global_mouse_position())
	elif Global.attacking == true:
		look_at(get_global_mouse_position())


func _on_range_body_entered(body):
	if body.name == "basemob":
		print("collide")
