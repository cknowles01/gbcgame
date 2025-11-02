extends Node

var player
var current_map: Node = null

var map_size: int = 300
var steps: int = 15000


signal change_map(next_map, spawn_point)

	
	
	
	
	
func set_player(p: Node2D) -> void:
	player = p

func set_map(map: Node) -> void:
	current_map = map

func move_player_to_spawn(spawn_name: String) -> void:
	if current_map and player:
		var spawn = current_map.get_node_or_null(spawn_name)
		if spawn:
			player.position = spawn.position

func move_player_to_spawnNode(spawn: Node) -> void:
	if player:
		if spawn is Node:
			player.position = spawn.position


func set_map_size(value: int):
	map_size = clamp(value, 50, 1000)
	
func set_steps(value: int):
	steps = clamp(value, 100, 100000)
