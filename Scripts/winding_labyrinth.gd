extends Node2D

const STEPS = 15000
const WALL = 0
const FLOOR = 1
 #dictionary: key = Vector2i(x, y), value = FLOOR/WALL
var dungeon = {} 

@onready var tilemap = $TileMap
@onready var wizard = preload("res://Scenes/enemy_wizard.tscn")
const FLOOR_COORD = Vector2i(0, 6)
const WALL_COORD = Vector2i(43,1) #1,11 is test and 
const STAIRS_COORD = Vector2i(3,9)
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
	#adds walls to the map
	dungeon.merge(new_walls)  

func _draw_dungeon():
	tilemap.clear()
	var halfway = dungeon.size()/2
	
	var counter = 1
	for pos in dungeon.keys():
		var is_floor = dungeon[pos] == FLOOR
		var atlas_coords = FLOOR_COORD if is_floor else WALL_COORD
		if counter == halfway:
			print('halwfay')
			$Spawn.global_position = pos * 16
		elif counter % 1000 == 0:
			var wizard_instance = wizard.instantiate()
			add_child(wizard_instance)
			wizard_instance.global_position = pos * 16
			#print("wizarde")
		elif counter == len(dungeon.keys()):
			atlas_coords = STAIRS_COORD
			print('testnd')
		counter += 1
		tilemap.set_cell(0, pos, 0, atlas_coords)



	
