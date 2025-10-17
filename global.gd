extends Node

var player
var current_map: Node = null

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
