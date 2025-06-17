extends CharacterBody2D
var speed = 250  

@onready var sprite = $sprite


func _physics_process(delta):
	var direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * speed
	if direction.x < 0:
		sprite.flip_h = true
	if direction.x > 0:
		sprite.flip_h = false
	move_and_slide()
