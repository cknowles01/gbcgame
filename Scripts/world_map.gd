extends TileMap



func _on_cave_1_enterance_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var direction = body.input_dir
		#print(direction)
		if direction.y < 0:
			print("Emit signal to go to Cave1 ")
			Global.change_map.emit("res://Scenes/Cave1.tscn", "CaveExit")
		


func _on_labyrinth_entrance_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var direction = body.input_dir
		#print(direction)
		if direction.y < 0:
			print("Emit Signal to enter Winding Labyrinth")
			Global.change_map.emit("res://Scenes/winding_labyrinth.tscn", "Spawn")
