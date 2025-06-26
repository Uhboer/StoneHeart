extends CharacterBody2D

@export var player: Node2D
@onready var navigation := $NavigationAgent2D as NavigationAgent2D

var speed = 20
var hp = 100
var isAlive = true
var isChasing = true
var timer : float
var wander : Vector2

enum States {IDLE, CHASE, DEATH, ATTACK}
var current_state = States.IDLE

func _ready() -> void:
	if player:
		makepath()

func state_change(new_state: States) -> void:  # Указан конкретный тип
	current_state = new_state

func random_wander():
	wander = Vector2(randf_range(1, -1), randf_range(1, -1)).normalized()
	timer = randf_range(1, 2)

func _physics_process(_delta: float) -> void:
	if current_state == States.DEATH or !player:
		return
	match current_state:
		States.IDLE:
			velocity = wander * speed
			if timer > 0:
				timer -= _delta
			else:
				random_wander()
			if global_position.distance_to(player.global_position) < 500:
				state_change(States.CHASE)
		States.CHASE:
			var dir = to_local(navigation.get_next_path_position()).normalized()
			velocity = dir * speed
			if global_position.distance_to(player.global_position) > 600:
				state_change(States.IDLE)
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	move_and_slide()
	death()
	#chase()
	
func death():
	if hp <= 0:
		state_change(States.DEATH)
		queue_free() #replace it with animation

func makepath() -> void:
	if player:
		navigation.target_position = player.global_position

func _on_timer_timeout() -> void:
	makepath()
