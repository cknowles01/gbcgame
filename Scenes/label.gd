extends Label



var blink_timer := 0.0

func _process(delta):
	blink_timer += delta
	modulate.a = (sin(blink_timer * 5) + 1) / 2  # fade in/out
