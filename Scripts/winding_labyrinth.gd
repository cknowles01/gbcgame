extends Node2D

# === CONFIG ===
var MAP_SIZE: int            # width & height of the dungeon grid
var STEPS: int             # number of random walk steps
const WALL = 0
const FLOOR = 1

const FLOOR_COORD = Vector2i(0, 6)
const WALL_COORD = Vector2i(43, 2)
const STAIRS_COORD = Vector2i(4, 5)
var spawn
@onready var tilemap: TileMap = $TileMap
@onready var wizard_scene = preload("res://Scenes/enemy_wizard.tscn")

# === DATA ===
var dungeon: Array = []         # 2D grid [x][y]
var thread: Thread = null

func _ready():
	randomize()
	MAP_SIZE = Global.map_size
	STEPS = Global.steps
	print("Map size is " + str(MAP_SIZE))
	print("Steps are " + str(STEPS))
	thread = Thread.new()
	#start generation in background thread
	thread.start(Callable(self, "_thread_generate_dungeon"))


func _exit_tree():
	#thread is done when node is removed
	if thread and thread.is_alive():
		thread.wait_to_finish()


# === BACKGROUND GENERATION THREAD ===
func _thread_generate_dungeon(userdata = null):
	# This enerate dungeon data
	_generate_dungeon()
	_generate_walls()
	
	#draws in main thread (i think required for visuals?)
	call_deferred("_draw_dungeon")
	#return; not supposed to wait call wait_to_finish() from inside the thread



func _generate_dungeon():
	# Initialize map
	dungeon.resize(MAP_SIZE)
	for x in range(MAP_SIZE):
		dungeon[x] = []
		for y in range(MAP_SIZE):
			dungeon[x].append(WALL)

	#Random walk cave
	var x = MAP_SIZE / 2
	var y = MAP_SIZE / 2

	for i in range(STEPS):
			
		dungeon[x][y] = FLOOR
		var dir = randi() % 4
		match dir:
			0: x = clamp(x + 1, 0, MAP_SIZE - 1)
			1: x = clamp(x - 1, 0, MAP_SIZE - 1)
			2: y = clamp(y + 1, 0, MAP_SIZE - 1)
			3: y = clamp(y - 1, 0, MAP_SIZE - 1)


func _generate_walls():
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			if dungeon[x][y] == FLOOR:
				# Use range(-1, 2) to iterate -1, 0, 1
				for dx in range(-1, 2):
					for dy in range(-1, 2):
						#skip the center tile itself
						if dx == 0 and dy == 0:
							continue
						var nx = x + dx
						var ny = y + dy
						if nx >= 0 and ny >= 0 and nx < MAP_SIZE and ny < MAP_SIZE:
							#mark wall if not floor (this should overwrite existing WALL with WALL but won't touch FLOOR)
							if dungeon[nx][ny] != FLOOR:
								dungeon[nx][ny] = WALL


# === DRAWING ===
func _draw_dungeon():
	tilemap.clear()

	var floor_cells: Array[Vector2i] = []
	var wall_cells: Array[Vector2i] = []

	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			if dungeon[x][y] == FLOOR:
				floor_cells.append(Vector2i(x, y))
			else:
				wall_cells.append(Vector2i(x, y))


	# ===== CHAT-GPT Responses for faster generation ===== #
	
	# Bulk placement: depends on your Godot version / TileMap setup.
	# If set_cells_terrain_path exists and fits your tileset, it's much faster:
	# tilemap.set_cells_terrain_path(0, floor_cells, 0)
	# tilemap.set_cells_terrain_path(0, wall_cells, 0)
	# If that API isn't available for your tileset, fall back to set_cell in a tight loop:
	
	for pos in floor_cells:
		tilemap.set_cell(0, pos, 0, FLOOR_COORD)
	for pos in wall_cells:
		tilemap.set_cell(0, pos, 0, WALL_COORD)

	#adds a few wizard enemies (randomly placed)
	var divider
	if floor_cells.size() > 0:
		if STEPS > 5000:
			for i in range(STEPS/1000):
				var pos = floor_cells[randi() % floor_cells.size()]
				var wizard = wizard_scene.instantiate()
				add_child(wizard)
				wizard.global_position = pos * 16
		else:
			for i in range(5):
				var pos = floor_cells[randi() % floor_cells.size()]
				var wizard = wizard_scene.instantiate()
				add_child(wizard)
				wizard.global_position = pos * 16

		# Player spawn, something is off
		var spawn = floor_cells[floor_cells.size() / 2]
		
		$LabyrinthSpawn.global_position = spawn * 16

		#Should place stair near last cell, not sure if i like it or not
		var stairs_pos = floor_cells.back()
		tilemap.set_cell(0, stairs_pos, 0, STAIRS_COORD)
		$LabyrinthExit.global_position = stairs_pos * 16
	

		print("Dungeon generated and drawn!")
		Global.move_player_to_spawnNode($LabyrinthSpawn)
		


func _on_labyrinth_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var direction = body.input_dir
		#print(direction)
		print("Emit Signal to enter Winding Labyrinth")
		Global.change_map.emit("res://Scenes/world_map.tscn", "LabyrinthBuilding")
