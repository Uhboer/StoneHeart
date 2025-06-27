extends Node

@onready var balance_label = $Balance
@onready var shop_item = preload("res://scenes/shop_item.tscn")
@onready var items = $Items

func _ready() -> void:
	var available_items = NiggaShop.get_avaliable_items()
	for item : Skill in available_items:
		var shop_item = shop_item.instantiate()
		items.add_child(shop_item)
		shop_item.set_item_name(item.get_skill_name())
		shop_item.set_item_price(item.get_cost())
		shop_item.set_icon(item.get_skill_icon())
		shop_item.set_skill(item)

func _process(delta: float) -> void:
	balance_label.text = str(Global.balance)
