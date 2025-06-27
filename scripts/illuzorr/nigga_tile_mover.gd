extends Node2D

@export var terrain_layer: TileMapLayer
@export var navigation_region: NavigationRegion2D
@export var player_node: NodePath
@export var view_distance := Vector2i(16, 12)
@export var walkable_tiles := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]  # Индексы проходимых тайлов
@export var max_loaded_chunks := 100

@export var generation_cooldown := 0.2  # Интервал генерации в секундах
var generation_timer := 0.0
var last_player_chunk := Vector2i.ZERO

@onready var player: CharacterBody2D = get_node_or_null(player_node)

var noise := FastNoiseLite.new()
var generated_chunks := {}
var loaded_chunks_queue := []
var nav_update_timer := 0.0
const CHUNK_SIZE := 8

func _ready():
	if !terrain_layer || !navigation_region:
		push_error("Не назначены необходимые ноды!")
		return

	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.05

func _process(delta):
	if !is_instance_valid(player):
		return
	
	generation_timer -= delta
	nav_update_timer -= delta
	
	# Получаем текущий чанк игрока
	var current_chunk = get_player_chunk_pos()
	
	# Генерация при движении между чанками или по таймеру
	if current_chunk != last_player_chunk || generation_timer <= 0:
		generate_around_player()
		last_player_chunk = current_chunk
		generation_timer = generation_cooldown
	
	# Обновление навигации по своему таймеру
	if nav_update_timer <= 0:
		update_navigation_region()
		nav_update_timer = 0.5
	
	cleanup_distant_chunks()

func generate_around_player():
	var player_pos = get_player_tile_pos()
	
	# Генерируем чанки в радиусе 2 от игрока
	for x in range(-2, 3):
		for y in range(-2, 3):
			var chunk_pos = Vector2i(
				last_player_chunk.x + x,
				last_player_chunk.y + y
			)
			if !generated_chunks.has(chunk_pos):
				generate_chunk(chunk_pos.x, chunk_pos.y)
				generated_chunks[chunk_pos] = true
				loaded_chunks_queue.append(chunk_pos)

func generate_chunks_around(pos: Vector2i):
	var chunk_pos = get_chunk_coords(pos)
	var safe_zone_radius = 2  # Чанки в этом радиусе никогда не удаляются
	
	# Генерируем область с запасом
	for x in range(chunk_pos.x - safe_zone_radius, chunk_pos.x + safe_zone_radius + 1):
		for y in range(chunk_pos.y - safe_zone_radius, chunk_pos.y + safe_zone_radius + 1):
			var chunk_key = Vector2i(x, y)
			if !generated_chunks.has(chunk_key):
				generate_chunk(x, y)
				generated_chunks[chunk_key] = true
				# Добавляем в начало очереди (новые чанки удаляются последними)
				loaded_chunks_queue.push_front(chunk_key)

func generate_chunk(chunk_x: int, chunk_y: int):
	var start_x = chunk_x * CHUNK_SIZE
	var start_y = chunk_y * CHUNK_SIZE
	
	for x in range(start_x, start_x + CHUNK_SIZE):
		for y in range(start_y, start_y + CHUNK_SIZE):
			var tile_pos = Vector2i(x, y)
			var tile_id = get_tile_type(tile_pos)
			# Исправленный вызов set_cell с правильными типами
			terrain_layer.set_cell(
				tile_pos,          # coords: Vector2i
				1,                 # source_id: int
				Vector2i(tile_id, 0),  # atlas_coords: Vector2i
				0                  # alternative_tile: int
			)

func clear_chunk(chunk_key: Vector2i):
	var start_x = chunk_key.x * CHUNK_SIZE
	var start_y = chunk_key.y * CHUNK_SIZE
	
	for x in range(start_x, start_x + CHUNK_SIZE):
		for y in range(start_y, start_y + CHUNK_SIZE):
			# Исправленный вызов erase_cell
			terrain_layer.erase_cell(Vector2i(x, y))  # Только coords: Vector2i
	
	generated_chunks.erase(chunk_key)

func cleanup_distant_chunks():
	if loaded_chunks_queue.size() <= max_loaded_chunks:
		return
	
	var player_chunk = get_player_chunk_pos()
	if player_chunk == Vector2i.ZERO:
		return
	
	# Создаем временный массив для сортировки
	var chunks_to_sort = []
	
	# Копируем чанки и рассчитываем расстояние до игрока
	for chunk in loaded_chunks_queue:
		chunks_to_sort.append({
			"pos": chunk,
			"distance": chunk.distance_squared_to(player_chunk)
		})
	
	# Сортируем по расстоянию (самые дальние в начале)
	chunks_to_sort.sort_custom(func(a, b): return a.distance > b.distance)
	
	# Удаляем только чанки, которые действительно далеко
	var chunks_to_remove = min(loaded_chunks_queue.size() - max_loaded_chunks, chunks_to_sort.size())
	
	for i in range(chunks_to_remove):
		var chunk_data = chunks_to_sort[i]
		# Не удаляем чанки в "буферной зоне" вокруг игрока
		if chunk_data.distance > (view_distance.length_squared() * 2):
			clear_chunk(chunk_data.pos)
			loaded_chunks_queue.erase(chunk_data.pos)
			generated_chunks.erase(chunk_data.pos)

func get_player_chunk_pos() -> Vector2i:
	var player_pos = get_player_tile_pos()
	if player_pos == Vector2i.ZERO:
		return Vector2i.ZERO
	return Vector2i(
		floori(player_pos.x / float(CHUNK_SIZE)),
		floori(player_pos.y / float(CHUNK_SIZE)))

func update_navigation(delta: float):
	if !navigation_region || !terrain_layer:
		return
	
	nav_update_timer -= delta
	if nav_update_timer <= 0:
		update_navigation_region()
		nav_update_timer = 0.5

func update_navigation_region():
	var player_pos = get_player_tile_pos()
	
	var navigation_polygon = NavigationPolygon.new()
	var outline = PackedVector2Array()
	var tile_size = Vector2(terrain_layer.tile_set.tile_size)
	
	for x in range(player_pos.x - view_distance.x, player_pos.x + view_distance.x + 1):
		for y in range(player_pos.y - view_distance.y, player_pos.y + view_distance.y + 1):
			var tile_pos = Vector2i(x, y)
			# Исправленный вызов get_cell_atlas_coords
			var atlas_coords = terrain_layer.get_cell_atlas_coords(tile_pos)
			if atlas_coords.x in walkable_tiles:
				var pos = terrain_layer.map_to_local(tile_pos)
				outline.append_array([
					pos,
					Vector2(pos.x + tile_size.x, pos.y),
					pos + tile_size,
					Vector2(pos.x, pos.y + tile_size.y)
				])
	
	navigation_polygon.add_outline(outline)
	navigation_polygon.make_polygons_from_outlines()
	navigation_region.navigation_polygon = navigation_polygon

func get_player_tile_pos() -> Vector2i:
	if !is_instance_valid(player) || !terrain_layer:
		return Vector2i.ZERO
	return terrain_layer.local_to_map(player.global_position)

func get_tile_type(pos: Vector2i) -> int:
	var value = noise.get_noise_2d(pos.x, pos.y)
	if value < -0.4:       return 1    # Deep Water
	elif value < -0.2:     return 2    # Shallow Water
	elif value < -0.05:    return 3    # Sand
	elif value < 0.1:      return 4    # Grass
	elif value < 0.25:     return 5    # Dark Grass
	elif value < 0.4:      return 6    # Dirt
	elif value < 0.6:      return 7    # Rocky Dirt
	elif value < 0.8:      return 8    # Stone
	else:                  return 9    # Mountain Stone

func get_chunk_coords(tile_pos: Vector2i) -> Vector2i:
	return Vector2i(
		floori(tile_pos.x / float(CHUNK_SIZE)),
		floori(tile_pos.y / float(CHUNK_SIZE)))

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		generated_chunks.clear()
		loaded_chunks_queue.clear()
