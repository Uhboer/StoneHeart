extends CharacterBody2D
var speed = 250  

@onready var sprite = $sprite
@onready var walkSound = $sounds/walk
@onready var weapons = $weapons
@onready var arc = $arc


func _physics_process(delta):
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * speed
	if velocity && !walkSound.playing:
		walkSound.play()
	
	if direction.x < 0:
		sprite.flip_h = true
		weapons.flip_h = true
	if direction.x > 0:
		sprite.flip_h = false
		weapons.flip_h = false
	
	
	attack()
	move_and_slide()


func attack():
	if Input.is_action_just_pressed("LMC") && Global.attacking == false:
		arc.visible = true
		Global.attacking == true
		await get_tree().create_timer(0.5).timeout
		arc.visible = false
		Global.attacking == false
		
