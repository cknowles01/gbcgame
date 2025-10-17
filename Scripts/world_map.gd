extends TileMap



func _on_cave_1_enterance_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var direction = body.input_dir
		#print(direction)
		if direction.y < 0:
			print(".y coords woek")
			Global.change_map.emit("res://Scenes/Cave1.tscn", "CaveExit")
		
