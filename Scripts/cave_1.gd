extends Node2D

#@onready var player = $Player




var player
@onready var current_map = $Cave
var last_map

func _ready():
	player = Global.player
	
	


func _on_cave1_exit(body: Node2D) -> void:
	if body.name == "Player":
		print("hopefully hccanger")
		var direction = body.input_dir
		if direction.y > 0:
			Global.change_map.emit("res://Scenes/world_map.tscn", "Cave1Entrance")
			print("changerchange")
