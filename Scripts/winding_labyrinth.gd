extends Node2D

const STEPS = 60000
const WALL = 0
const FLOOR = 1
var dungeon = {}  # use dictionary: key = Vector2i(x, y), value = FLOOR/WALL

@onready var tilemap = $TileMap

const FLOOR_COORD = Vector2i(0, 6)
const WALL_COORD = Vector2i(1, 11)

func _ready():
	randomize()
	_generate_dungeon()
	_generate_walls()
	_draw_dungeon()

func _generate_dungeon():
	var x = 150
	var y = 150
	dungeon[Vector2i(x, y)] = FLOOR

	for i in range(STEPS):
		var ran = randi() % 4
		match ran:
			0: x += 1
			1: x -= 1
			2: y += 1
			3: y -= 1

		dungeon[Vector2i(x, y)] = FLOOR

func _generate_walls():
	var directions = [
		Vector2i(1, 0), Vector2i(-1, 0),
		Vector2i(0, 1), Vector2i(0, -1),
		Vector2i(1, 1), Vector2i(-1, 1),
		Vector2i(1, -1), Vector2i(-1, -1)
	]

	var new_walls = {}
	for pos in dungeon.keys():
		for dir in directions:
			var neighbor = pos + dir
			if not dungeon.has(neighbor):
				new_walls[neighbor] = WALL
	dungeon.merge(new_walls)  # add walls to the map

func _draw_dungeon():
	tilemap.clear()
	var halfway = dungeon.size()/2
	print(halfway)
	print(dungeon.size())
	var counter = 1
	for pos in dungeon.keys():
		var is_floor = dungeon[pos] == FLOOR
		var atlas_coords = FLOOR_COORD if is_floor else WALL_COORD
		if counter == halfway:
			print('halwfay')
			
			$Spawn.global_position = pos * 16
		counter += 1
		tilemap.set_cell(0, pos, 0, atlas_coords)



	
