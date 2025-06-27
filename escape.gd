extends CanvasLayer

@onready var Return = $Control/VBoxContainer/Return

func _physics_process(delta: float) -> void:
	if is_action_pressed():
		pass

func _on_return_pressed() -> void:
	Return.visible = !Return.visible
