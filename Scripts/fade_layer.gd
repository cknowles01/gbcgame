extends CanvasLayer


@onready var rect = $ColorRect

func fade_out():
	rect.modulate.a = 0
	rect.visible = true
	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 0.5)
	await tween.finished

func fade_in():
	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, 0.5)
	await tween.finished
	rect.visible = false
