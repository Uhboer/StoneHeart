extends Node

@onready var world = $".."
@onready var tile_map = $"../TileMapLayer"
@onready var observer_cam : Camera2D = $ObserverCam

var last_player_position
var in_smoothing = false
var zooming_speed = 1.001
var min_zoom : Vector2 = Vector2(2, 2)

func _process(delta: float) -> void:
	var player_is_alive = false
	
	for child in world.get_children():
		if (child.name == "player"):
			last_player_position = child.position
			player_is_alive = true
			
	if (!player_is_alive):
		observer_cam.position = last_player_position
		observer_cam.make_current()
		in_smoothing = true
	
	if (observer_cam.zoom < min_zoom):
			in_smoothing = false
		
	if (in_smoothing):
		var last_zoom : Vector2 = observer_cam.zoom
		var new_zoom = Vector2(last_zoom.x / zooming_speed, last_zoom.y / zooming_speed)
		observer_cam.zoom = new_zoom
	
	if (observer_cam.is_current):
		return
