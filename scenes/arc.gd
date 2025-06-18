extends Node2D

@onready var attack = $attack


func _process(delta):
	look_at(get_global_mouse_position())
