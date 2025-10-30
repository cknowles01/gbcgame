extends CanvasLayer

@onready var menu = $Control

func _ready():
	menu.visible = false
	$Control/ResumeButton.pressed.connect(_on_resume_pressed)
	$Control/QuitButton.pressed.connect(_on_quit_pressed)

func toggle():
	if menu.visible:
		hide_menu()
	else:
		show_menu()

func show_menu():
	menu.visible = true
	get_tree().paused = true

func hide_menu():
	menu.visible = false
	get_tree().paused = false

func _on_resume_pressed():
	hide_menu()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
