extends Node2D



@export var item_name: String = "Coin"  # what this chest gives
var is_open: bool = false

@onready var sprite = $Sprite

func _on_body_entered(body: Node) -> void:
	if is_open:
		return
	if body.name == "Player":
		
		open_chest(body)

func open_chest(player):
	is_open = true
	
	print("You got a %s!" % item_name)

	# Example: give the item to the player
	if player.has_method("give_item"):
		player.give_item(item_name)

	# Optional: play a sound
	
