extends Node2D

@export var view_distance := Vector2i(20, 15)  # Visible tiles around player
@export var terrain_layer: TileMapLayer  # Assign in Inspector
@export var player: CharacterBody2D  # Assign in Inspector

@export var navigation_region: NavigationRegion2D
@export var walkable_tiles := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]  # Индексы проходимых тайлов (трава, земля)

var last_update = 0
var suka = 1

var noise := FastNoiseLite.new()
var generated_tiles := {}

func _ready():
	# Noise setup
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.05
	generate_around_player()

func _process(_delta):
	generate_around_player()

func generate_around_player():
	if !player || !terrain_layer: return
	
	if Time.get_unix_time_from_system() > last_update + 1:
		last_update = Time.get_unix_time_from_system()
	else:
		return
	
	var tile_size = terrain_layer.tile_set.tile_size
	var player_tile_pos = Vector2i(
		floor(player.global_position.x / tile_size.x),
		floor(player.global_position.y / tile_size.y)
	)
	
	var start = player_tile_pos - view_distance
	var end = player_tile_pos + view_distance
	
	for x in range(start.x, end.x + 1):
		for y in range(start.y, end.y + 1):
			var tile_pos = Vector2i(x, y)
			if !generated_tiles.has(tile_pos):
				var tile_id = get_tile_type(tile_pos)
				var old_cell = terrain_layer.get_cell_atlas_coords(tile_pos)
				var new_cell = Vector2i(tile_id, 0)
				terrain_layer.set_cell(
					tile_pos,  # coords: Vector2i
					1,        # source_id: int (your tileset source ID)
					new_cell,  # atlas_coords: Vector2i
					0         # alternative_tile: int
				)
				generated_tiles[tile_pos] = true

func get_tile_type(pos: Vector2i) -> int:
	var value = noise.get_noise_2d(pos.x, pos.y)
	if value < -0.2: return 1    # Water
	elif value < 0.2: return 0   # Grass
	elif value < 0.5: return 2   # Dirt
	else: return 3               # Stone
