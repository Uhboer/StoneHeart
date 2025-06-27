extends CharacterBody2D
var speed = 250  

@onready var sprite = $sprite
@onready var walkSound = $sounds/walk
@onready var weaponsAnim = $weaponsanim
@onready var arc = $arc

@onready var weapon_system = $weapon_system


func _physics_process(_delta):
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * speed
	if velocity && !walkSound.playing:
		walkSound.play()
	
	if direction.x < 0:
		sprite.flip_h = true
		weaponsAnim.flip_h = true
	if direction.x > 0:
		sprite.flip_h = false
		weaponsAnim.flip_h = false
	
	
	input()
	move_and_slide()

func input():
	if Input.is_action_pressed("LMC"):
		weapon_system.attack()
