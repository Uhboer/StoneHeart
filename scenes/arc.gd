extends Node2D

@onready var attack = $attack


func _process(delta):
	if Global.attacking == false:
		look_at(get_global_mouse_position())
	elif Global.attacking == true:
		look_at(get_global_mouse_position())
