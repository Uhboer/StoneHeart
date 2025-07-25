extends Node

static var _all_skills = []
static var _avaliable_for_purchase = []
static var _purchased_skills = []

func _ready() -> void:
	# test()
	pass

static func get_avaliable_items():
	return _avaliable_for_purchase.duplicate()

func test():
	add_balance(100)
	
	var first_skill = _avaliable_for_purchase.get(0)
	if (first_skill == null):
		push_error("Can't find skills to make a purchase!")
		return
	
	var second_skill = _avaliable_for_purchase.get(1)
	if (second_skill == null):
		push_error("Can't find skills to make a purchase!")
		return
	
	print("Your balance is " + str(Global.balance) + "$!")
	print("You want to buy some skills!")
	
	purchase_skill(first_skill)
	purchase_skill(first_skill)
	purchase_skill(first_skill)
	purchase_skill(first_skill)
	purchase_skill(first_skill)
	
	purchase_skill(second_skill)
	
	print("You have now " + str(_purchased_skills.size()) + " skills!")
	print("Your balance is " + str(Global.balance) + "$!")
	
	var bonus_health = 0
	for skill : Skill in _purchased_skills:
		if (skill.get_operation_category("add").size() > 0):
			bonus_health += skill.get_modificator("health", "add")
	var bonus_health_multiplier = 1
	for skill : Skill in _purchased_skills:
		if (skill.get_operation_category("multiply").size() > 0):
			bonus_health_multiplier += skill.get_modificator("health", "multiply")
			
	print("You have " + str(bonus_health) + " bonus health points!")
	print("You have " + str(bonus_health_multiplier) + " bonus health points multiplier!")
	print("Total HP: " + str(bonus_health * bonus_health_multiplier))

func _init() -> void:
	make_skills()
	init_avaliable_for_purchase()

static func add_balance(money : int):
	Global.balance += money
	NiggaSave.save_player_data() # wtf
	
static func get_balance():
	return Global.balance
	
static func remove_balance(money : int):
	Global.balance = max(Global.balance - money, 0)
	NiggaSave.save_player_data() # wtf

func add_skill(new_skill : Skill):
	if (_all_skills.has(new_skill)):
		push_error("Try to add a duplicate of " + new_skill.get_skill_name() + "!")
		return
	_all_skills.append(new_skill)
	
static func purchase_skill(skill : Skill):
	if (!_avaliable_for_purchase.has(skill)):
		push_error("No skills to make purchase of " + skill.get_skill_name() + "!")
		return false
	if (Global.balance >= skill.get_cost()):
		remove_balance(skill.get_cost())
		if (!skill.is_repeatable()):
			_avaliable_for_purchase.erase(skill)
		print("You make a purchase of " + skill.get_skill_name() + " for " + str(skill.get_cost()) + "$!")
		_purchased_skills.append(skill)
		return true
	else:
		push_error("No money to make purchase of " + skill.get_skill_name() + "!")
		return false
	
func init_avaliable_for_purchase():
	_avaliable_for_purchase = _all_skills.duplicate()

func make_skills():
	add_skill(Skill.new("gg", 777, true, "res://icon.svg").add_modificator("health", 10, "add"))
	add_skill(Skill.new("bonus10health", 12).add_modificator("health", 10, "add"))
	add_skill(Skill.new("bonus24healthmultiplier", 25).add_modificator("health", 24, "multiply"))

func get_all_skills():
	return _all_skills

func pick_random_skills(count : int):
	if _avaliable_for_purchase.size() == 0:
		push_error("No skills to choose from!")
		return
	if _avaliable_for_purchase.size() < count:
		push_error("Not enough skills to choose from!")
		return
	var skills = []
	for i in count:
		skills.append(_avaliable_for_purchase.pick_random())
	return skills
