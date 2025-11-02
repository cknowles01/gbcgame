extends Control

@onready var main_menu = $VBoxContainer
@onready var settings_panel = $SettingsPanel
@onready var play_button = $VBoxContainer/Play
@onready var settings_button = $VBoxContainer/Settings
@onready var quit_button = $VBoxContainer/Quit
@onready var map_size_box = $SettingsPanel/VBoxContainer/MapSizeSpinbox
@onready var steps_box = $SettingsPanel/VBoxContainer/StepSpinbox
@onready var back_button = $SettingsPanel/VBoxContainer/BackButton

func _ready():
	# Only set SpinBox defaults ONCE at startup
	map_size_box.min_value = 50
	map_size_box.max_value = 1000
	map_size_box.step = 1
	map_size_box.value = Global.map_size   # initial value

	steps_box.min_value = 100
	steps_box.max_value = 100000
	steps_box.step = 100
	steps_box.value = Global.steps         # initial value

	settings_panel.visible = false

	# Connect signals
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	back_button.pressed.connect(_on_back_pressed)







func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed(toggled_on: bool):
	# Hide main menu, show settings
	if false:
		main_menu.visible = false
		settings_panel.visible = true
	else:
		settings_panel.visible = true


func _on_back_pressed():
	# Save chosen settings
	Global.set_map_size(map_size_box.value)
	Global.set_steps(steps_box.value)
	main_menu.visible = true
	settings_panel.visible = false

func _on_map_size_spinbox_value_changed(value: float) -> void:
	Global.map_size = value
	print(Global.map_size)
	


func _on_step_spinbox_value_changed(value: float) -> void:
	Global.steps = value


func _on_settings_toggled(toggled_on: bool) -> void:
	if true:
		main_menu.visible = false
		settings_panel.visible = true
	else:
		main_menu.visible = true
		settings_panel.visible =false
	
