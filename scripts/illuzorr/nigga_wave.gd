extends Node

@onready var enemy_scene = preload("res://scenes/basemob.tscn")
@onready var player = $"../player"
@onready var world = $"."

var current_wave: int = 0
var wave_is_active: bool = false
@export var wave_duration: float = 3.0
@export var wave_cooldown: float = 3.0
@export var enemies_per_wave: int = 1
var wave_spawned_enemies: Array[Node] = []
@export var max_distance_x: float = 200.0
@export var min_distance_x: float = -200.0
@export var max_distance_y: float = 200.0
@export var min_distance_y: float = -200.0
@export var min_distance_from_player: float = 150.0 # Минимальное расстояние от игрока
@export var max_distance_from_player: float = 400.0 # Максимальное расстояние от игрока

@export var max_enemy_distance: float = 1000.0 # Максимальное расстояние, после которого враг удаляется
@export var max_enemies: int = 50 # Максимальное количество врагов на сцене

var wave_start_time: float = 0.0

func start_new_wave() -> void:
	current_wave += 1
	enemies_per_wave += 1
	wave_spawned_enemies.clear()
	wave_is_active = true
	wave_start_time = Time.get_unix_time_from_system()
	print("Wave ", current_wave, " started!")

func spawn_enemy() -> void:
	if get_tree().get_nodes_in_group("enemy").size() >= max_enemies:
		return
		
	if enemy_scene == null:
		printerr("Error: Enemy scene is not assigned!")
		return

	var new_enemy = enemy_scene.instantiate()
	world.add_child(new_enemy)
	
	new_enemy.add_to_group("enemy")
	
	# new_enemy.scale = Vector2(0.5, 0.5)

	var player_pos
	
	if player != null:
		player_pos = player.position
	else:
		player_pos = Vector2.ZERO
		
	var random_angle = randf() * PI * 2.0  # Случайный угол в радианах (0 - 2*PI)
	var random_distance = randf_range(min_distance_from_player, max_distance_from_player)

	var spawn_x = cos(random_angle) * random_distance + player_pos.x
	var spawn_y = sin(random_angle) * random_distance + player_pos.y
	var spawn_position = Vector2(spawn_x, spawn_y)
			
	new_enemy.position = spawn_position
	wave_spawned_enemies.append(new_enemy)

func _init() -> void:
	randomize()
	#start_new_wave() #Don't start wave in init. Instead do this in _ready so the other nodes are ready.

func _ready() -> void:
	start_new_wave()

func _process(delta: float) -> void:
	var current_time = Time.get_unix_time_from_system()

	cleanup_distant_enemies()

	if !wave_is_active:
		if current_time > wave_start_time + wave_cooldown:
			if player != null:
				start_new_wave()
	else:
		if wave_spawned_enemies.size() < enemies_per_wave:
			spawn_enemy()

		if current_time > wave_start_time + wave_duration:
			wave_is_active = false
			print("Wave ", current_wave, " ended! Cooldown starting.")

func cleanup_distant_enemies() -> void:
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if enemy.position.distance_to(player.position) > max_enemy_distance:
			if enemy in wave_spawned_enemies:
				wave_spawned_enemies.erase(enemy)
			enemy.queue_free()
