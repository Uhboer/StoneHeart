extends Node

@onready var item_icon = $Panel/Icon
@onready var item_name = $Panel/Name
@onready var item_price = $Panel/Price

var skill : Skill

func set_icon(icon : Texture2D):
	item_icon.texture = icon

func set_skill(new_skill: Skill):
	skill = new_skill

func set_item_name(new_name: String):
	item_name.text = new_name
	
func set_item_price(price: int):
	item_price.text = str(price)

func _on_buy_pressed() -> void:
	if !skill:
		return
	if NiggaShop.purchase_skill(skill):
		queue_free()
