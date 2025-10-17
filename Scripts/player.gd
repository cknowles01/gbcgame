extends CharacterBody2D

# === CONFIG ===
const TILE_SIZE := 16            #grid size is 16
var MOVE_TIME := 0.12            #unused
const SWING_COOLDOWN = .5
var swing_timer = 0.0
var is_swinging = false
# === STATE ===
var moving := false
var target_position : Vector2
var dir := Vector2.DOWN          #default facing direction
var facing := Vector2.ZERO

var input_dir
# --- ITEMS AND MENU STUFF ---


var timer := Timer.new()

var inventory = {}
var equipped_weapon: String = ""
@onready var sword = $Sword
@onready var anim := $AnimatedSprite2D
@onready var tilemap := get_parent().get_node("TileMap")

func _ready():
	
	# snap player to grid
	self.add_to_group("Player")
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	target_position = position
	z_index = 10
	sword.visible = false
	Global.set_player(self)
	



func _physics_process(delta):
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	#I think i want to do my sword animation
	match input_dir:
		Vector2.LEFT:
			print("We are now going left!!!!!!")
			sword_direction(Vector2.LEFT)
		Vector2.RIGHT:
			print("We are going right")
			sword_direction(Vector2.RIGHT)
		Vector2.UP:
			print("WE're going up@")
			sword_direction(Vector2.UP)
		Vector2.DOWN:
			print("SDfdS")
			sword_direction(Vector2.DOWN)
		
		
	#input_dir seems to return an x and y value, either -1, 0, or 1
	print(input_dir)
	input_dir * TILE_SIZE
	velocity = input_dir * 80
	
	if input_dir && is_swinging == false:
		play_walk_animation(input_dir)
	else:
		play_idle_animation()
	
	
	if Input.is_action_just_pressed("ui_select"):
		print("swinging sword!!!")
		start_swing()
		sword_direction(input_dir)
		
	
	if is_swinging:
		swing_timer -= delta   
		if swing_timer <= 0:
			is_swinging = false
			sword.visible = false
	facing = input_dir
	move_and_slide()
	




# --- Animations ---
func play_walk_animation(dir: Vector2):
	if dir == Vector2.RIGHT:
		anim.play("walk_right")
	elif dir == Vector2.LEFT:
		anim.play("walk_left")
	elif dir == Vector2.UP:
		anim.play("walk_up")
	elif dir == Vector2.DOWN:
		anim.play("walk_down")

func play_swing_animation(dir):
	if dir == Vector2.RIGHT:
		anim.play("swing_right")
	elif dir == Vector2.LEFT:
		anim.play("swing_left")
	elif dir == Vector2.UP:
		anim.play("swing_up")
	elif dir == Vector2.DOWN:
		anim.play("swing_down")

func play_idle_animation():
	match dir:
		Vector2.RIGHT: anim.play("idle_right")
		Vector2.LEFT: anim.play("idle_left")
		Vector2.UP: anim.play("idle_up")
		Vector2.DOWN: anim.play("idle_down")
		

func give_item(item_name: String):
	if inventory.has(item_name):
		inventory[item_name] += 1
	else:
		inventory[item_name] = 1
	print("Obtained %s! Inventory: %s" % [item_name, inventory])
	

func start_swing():
	is_swinging = true
	swing_timer = SWING_COOLDOWN
	sword.visible = true
	#sword.position = Vector2(8, -16)
	sword.play("swing")
	
func sword_direction(facing):
	if sword.visible == true:
		if facing == Vector2.UP:
			sword.rotation_degrees = 0
			sword.position = Vector2(0, -16)
		elif facing == Vector2.DOWN:
			#sword needs to face left first, i think
			
			#This is the first frame of the down swing and it looks good
			sword.rotation_degrees = -90
			sword.position = Vector2(-14, 4)
			
			timer.wait_time = .2
			sword.play("swingFrame2")
			
			
		elif facing == Vector2.LEFT:
			sword.rotation_degrees = -90
			sword.position = Vector2(-16, 0)
		elif facing == Vector2.RIGHT:
			print("FUCNIGN WORD")
			sword.rotation_degrees = 90
			sword.position = Vector2(16, 0)
	
	
func equip_weapon(item_name: String):
	if inventory.has(item_name):
		equipped_weapon = item_name
		print("You equipped %s!" % [item_name])
