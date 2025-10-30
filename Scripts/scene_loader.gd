extends Node2D

var player = preload("res://Scenes/player.tscn")
var main_menu = preload("res://Scenes/main_menu.tscn")
var current_map 
var last_map

func _ready():
	Global.change_map.connect(_on_change_map)
	player = player.instantiate()
	add_child(player)
	current_map = preload("res://Scenes/world_map.tscn")
	current_map = current_map.instantiate()
	add_child(current_map)

	
	main_menu = main_menu.instantiate()
	add_child(main_menu)
	
	
func _on_change_map(next_map_path: String, spawn_point_loc: String):
	print(spawn_point_loc)
	if current_map:
		current_map.queue_free()
	var next_map = load(next_map_path).instantiate()
	current_map = next_map
	add_child(next_map)
	var spawn_point = next_map.get_node(spawn_point_loc)
	
	if spawn_point == null:
		push_warning("can't find a spawn point" % [spawn_point_loc, next_map_path])
		return
	
	player.global_position = spawn_point.global_position

		
	
