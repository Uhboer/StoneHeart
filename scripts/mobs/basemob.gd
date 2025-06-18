extends CharacterBody2D

var speed = 200
var hp = 100
var isAlive = true

func _physics_process(_delta):
	if !isAlive:
		return
	move_and_slide()
	if velocity.length() > 0:
		$AnimatedSprite2D.play("run")
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
