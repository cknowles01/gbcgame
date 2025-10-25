extends Node2D

#Dungeon parameters
const WIDTH = 500
const HEIGHT = 500
const STEPS = 40000
const WALL = 0
const FLOOR = 1




const ENEMY_SPAWNER = 500
const CHEST_SPAWNER = 2000
var dungeon = []

# TileMap reference
@onready var tilemap = $TileMap
@onready var Chest = $Chest
# --- TileSet atlas coordinates ---
const FLOOR_COORD = Vector2i(0, 6)  
const WALL_COORD = Vector2i(1, 11) #43,2
const ALTERNATIVE = 0 #don't even think i need this

func _ready():
	randomize()
	_generate_dungeon()
	_draw_dungeon()

func _generate_dungeon():
	#Initialize the dungeon filled with walls
	dungeon.resize(HEIGHT)
	for y in range(HEIGHT):
		dungeon[y] = []
		#takes forever and i don't know if it's all that necessary
		for x in range(WIDTH):
			print(y)
			dungeon[y].append(WALL)
	
	#Start in the center - Doesn't work
	var x = 250 as int
	var y =  100 as int

	var prev = 1
	#random walking
	for i in range(STEPS):
		if i == STEPS/2:
			$Spawn.global_position = Vector2(x,y)*16
		dungeon[x][y] = FLOOR
		print(FLOOR)
		#print(FLOOR)
		#pick a random direction
		if i % 2 == 0:
			var ran = randi() % 4
		
			match ran:
				0: x += 1 
				1: x -= 1
				2: y += 1
				3: y -= 1
		#prev=ran

		
		x = clamp(x, 1, WIDTH - 2)
		y = clamp(y, 1, HEIGHT - 2)



func _draw_dungeon():
	tilemap.clear() 
	#print("drawing dungeon")
	var tileset = tilemap.tile_set
	var source_id = 0
	if source_id == -1:
		push_error("Tileset not found!!!!")
		return

	for y in range(HEIGHT):
		for x in range(WIDTH):
			var atlas_coords = FLOOR_COORD if dungeon[x][y] == FLOOR else WALL_COORD
			#print(atlas_coords)
			#print(Vector2i(x,y))
			tilemap.set_cell(0, Vector2i(x, y), source_id, atlas_coords, 0)
 
			


	
