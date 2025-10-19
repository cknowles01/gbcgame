extends Node2D

# Dungeon parameters
const WIDTH = 3000
const HEIGHT = 3000
const STEPS = 2000
const WALL = 0
const FLOOR = 1

var dungeon = []

# TileMap reference
@onready var tilemap = $TileMap

# --- TileSet atlas coordinates ---
const FLOOR_COORD = Vector2i(0, 6)  
const WALL_COORD = Vector2i(43, 2) 
const ALTERNATIVE = 0 #don't even think i need this

func _ready():
	randomize()
	_generate_dungeon()
	_draw_dungeon()

func _generate_dungeon():
	# Initialize dungeon filled with walls
	dungeon.resize(HEIGHT)
	for y in range(HEIGHT):
		dungeon[y] = []
		for x in range(WIDTH):
			dungeon[y].append(WALL)
	
	#Start in the center
	var x = WIDTH / 2 as int
	var y = HEIGHT / 2 as int

	#random waling
	for i in range(STEPS):
		dungeon[y][x] = FLOOR

		#pick a random direction
		match randi() % 4:
			0: x += 1
			1: x -= 1
			2: y += 1
			3: y -= 1

		
		x = clamp(x, 1, WIDTH - 2)
		y = clamp(y, 1, HEIGHT - 2)

func _draw_dungeon():
	tilemap.clear() 

	var tileset = tilemap.tile_set
	var source_id = 0
	if source_id == -1:
		push_error("Tileset source not found!")
		return

	
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var atlas_coords = FLOOR_COORD if dungeon[y][x] == FLOOR else WALL_COORD
			tilemap.set_cell(x, y, 0, source_id, atlas_coords) 


	
