extends Node
class_name NiggaSave

static var save_path = "user://StoneHeart.gb" # PASHALKA.gb))

func _init():
	print("Hi!")
	
func _ready() -> void:
	load_player_data()

func load_player_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		Global.balance = file.get_var(Global.balance)

static func save_player_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Global.balance)
