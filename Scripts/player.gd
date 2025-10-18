extends CharacterBody2D

# === CONFIG ===
const TILE_SIZE := 16
const MOVE_SPEED := 80
const SWING_COOLDOWN := 0.5

# === STATE ===
var swing_timer := 0.0
var is_swinging := false
var moving := false
var target_position : Vector2
var dir := Vector2.DOWN          # default facing direction
var facing := Vector2.ZERO
var input_dir := Vector2.ZERO

# --- ITEMS AND MENU STUFF ---
var inventory = {}
var equipped_weapon: String = ""

# === NODES ===
@onready var sword: AnimatedSprite2D = $Sword
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var tilemap := get_parent().get_node("TileMap")
@onready var timer: Timer = Timer.new()
@onready var hitbox = $Sword/Hitbox

func _ready():
	add_child(timer)
	timer.one_shot = true
	sword.visible = false
	Global.set_player(self)
	add_to_group("Player")

	# Snap player to grid
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	target_position = position
	z_index = 10


func _physics_process(delta):
	# --- INPUT ---
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * MOVE_SPEED

	# --- MOVEMENT ANIMATION ---
	if input_dir and not is_swinging:
		play_walk_animation(input_dir)
	elif not is_swinging:
		play_idle_animation()

		

	# --- ATTACK ---
	if Input.is_action_just_pressed("ui_select"):
		start_swing()

	# --- UPDATE SWING STATE ---
	if is_swinging:
		swing_timer -= delta
		if swing_timer <= 0:
			is_swinging = false
			sword.visible = false

	# Update facing direction if moving
	if input_dir != Vector2.ZERO:
		facing = input_dir
	move_and_slide()

# === ANIMATIONS ===
func play_walk_animation(dir: Vector2):
	if dir == Vector2.RIGHT:
		anim.play("walk_right")
	elif dir == Vector2.LEFT:
		anim.play("walk_left")
	elif dir == Vector2.UP:
		anim.play("walk_up")
	elif dir == Vector2.DOWN:
		anim.play("walk_down")

func play_idle_animation():
	match dir:
		Vector2.RIGHT: anim.play("idle_right")
		Vector2.LEFT: anim.play("idle_left")
		Vector2.UP: anim.play("idle_up")
		Vector2.DOWN: anim.play("idle_down")

func play_swing_animation(dir: Vector2):
	if dir == Vector2.RIGHT:
		anim.play("swing_right")
	elif dir == Vector2.LEFT:
		anim.play("swing_left")
	elif dir == Vector2.UP:
		anim.play("swing_up")
	elif dir == Vector2.DOWN:
		anim.play("swing_down")

# === INVENTORY ===
func give_item(item_name: String):
	if inventory.has(item_name):
		inventory[item_name] += 1
	else:
		inventory[item_name] = 1
	print("Obtained %s! Inventory: %s" % [item_name, inventory])

func equip_weapon(item_name: String):
	if inventory.has(item_name):
		equipped_weapon = item_name
		print("You equipped %s!" % [item_name])

# === SWORD LOGIC ===
func start_swing():
	if is_swinging:
		return  # don’t interrupt a swing

	is_swinging = true
	swing_timer = SWING_COOLDOWN
	sword.visible = true
	
	#--- FOR HITBOX --- #
	hitbox.monitoring = true
	
	
	
	# Lock current direction for the swing
	var dir_to_use = facing if facing != Vector2.ZERO else dir
	dir = dir_to_use
	timer.stop()
	sword.play("swingFrame1")
	# Set first frame
	_set_sword_start_pose(dir_to_use)


	# Reset and connect timer events cleanly
	if timer.timeout.is_connected(on_swing_end):
		timer.timeout.disconnect(on_swing_end)
	if timer.timeout.is_connected(on_swing_mid):
		timer.timeout.disconnect(on_swing_mid)

	timer.wait_time = 0.12
	timer.start()
	timer.timeout.connect(on_swing_mid)

func _set_sword_start_pose(facing: Vector2):
	sword.play("swingFrame1")
	match facing:
		Vector2.UP:
			sword.rotation_degrees = 90
			sword.position = Vector2(14, 4)
		Vector2.DOWN:
			sword.rotation_degrees = -90
			sword.position = Vector2(-14, 4)
		Vector2.LEFT:
			sword.rotation_degrees = 0
			sword.position = Vector2(-4, -14)
		Vector2.RIGHT:
			sword.rotation_degrees = 180
			sword.position = Vector2(4, 14)

func on_swing_mid():
	sword.play("swingFrame2")
	# Slight motion adjustment for visual arc
	match dir:
		Vector2.UP:
			sword.position = Vector2(14, -14)
			sword.rotation_degrees = 0
		Vector2.DOWN:
			sword.position = Vector2(-14, 14)
			sword.rotation_degrees = 180
		Vector2.LEFT:
			sword.position = Vector2(-18, -14)
			sword.rotation_degrees = 270
		Vector2.RIGHT:
			sword.position = Vector2(18, 14)
			sword.rotation_degrees = 90

	timer.stop()
	# Prepare to finish swing
	if timer.timeout.is_connected(on_swing_mid):
		timer.timeout.disconnect(on_swing_mid)
	
	timer.wait_time = 0.12
	timer.start()
	timer.timeout.connect(on_swing_end)

func on_swing_end():
	sword.play("swingFrame1")
	match dir:
		Vector2.UP:
			sword.position = Vector2(0, -14)
			sword.rotation_degrees = 0
		Vector2.DOWN:
			sword.position = Vector2(0, 14)
			sword.rotation_degrees = 180
		Vector2.LEFT:
			sword.position = Vector2(-14, 0)
			sword.rotation_degrees = -90
		Vector2.RIGHT:
			sword.position = Vector2(14, 0)
			sword.rotation_degrees = 90
	if timer.timeout.is_connected(on_swing_end):
		timer.timeout.disconnect(on_swing_end)
	timer.stop()
	timer.wait_time = .12
	timer.start()
	timer.timeout.connect(_hide_sword)
	
func _hide_sword():
	sword.visible = false
	is_swinging = false
	hitbox.monitoring = false
	timer.stop()
	if timer.timeout.is_connected(_hide_sword):
		timer.timeout.disconnect(_hide_sword)
	
	
	


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1)
	
