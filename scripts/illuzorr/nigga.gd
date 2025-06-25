extends Node

@onready var player = $".."

func _on_body_exited(body: Node2D) -> void:
	if (body.name == "TileMapLayer"):
		player.queue_free()
