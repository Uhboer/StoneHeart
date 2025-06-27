class_name Skill

var _skill_name = "NONE"
var _skill_icon = preload("res://spritos/patrik_template.jpg")
var _cost = 0
var _repeatable = true
var _modificators = {"add": {}, "multiply": {}}

func _init(skill_name : String, cost : int = 1, repeatable : bool = true, skill_icon : String = "") -> void:
	_skill_name = skill_name
	_repeatable = repeatable
	_cost = cost
	if skill_icon != "":
		_skill_icon = load(skill_icon)

func get_skill_icon():
	return _skill_icon

func get_skill_name():
	return _skill_name
	
func get_cost():
	return _cost
	
func is_repeatable():
	return _repeatable

func add_modificator(modificator_name : String, value : float, operation_type : String):
	if (!_modificators.has(operation_type)):
		push_error("Ты invalid operation type!")
		return null
	
	var operation_category : Dictionary = _modificators.get(operation_type)
	
	if (operation_category.has(modificator_name)):
		push_error("Try to add a duplicate of " + modificator_name + "!")
		return null
		
	operation_category.get_or_add(modificator_name, value)
	_modificators.erase(operation_type)
	_modificators.get_or_add(operation_type, operation_category)
	return self

func get_modificator(modificator_name : String, operation_type : String):
	if (!_modificators.has(operation_type)):
		push_error("Ты invalid operation type!")
		return null
	
	var operation_category : Dictionary = _modificators.get(operation_type)
	
	return operation_category.get(modificator_name)

func get_operation_category(operation_type : String):
	if (!_modificators.has(operation_type)):
		push_error("Ты invalid operation type!")
		return null
	return _modificators.get(operation_type)
