extends CanvasLayer

@onready var menu = $Menu
@onready var shop = $Shop

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	menu.visible = !menu.visible
	shop.visible = !shop.visible


func _on_exit_shop_pressed() -> void:
	menu.visible = !menu.visible
	shop.visible = !shop.visible
	
