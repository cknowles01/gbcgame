extends CharacterBody2D

# === CONFIG ===
var health = 3

# --- Knockback ---
var knockback_velocity = Vector2.ZERO
const KNOCKBACK_FORCE = 100.0
const KNOCKBACK_DECAY = 10.0  # how fast it slows down

# --- Enemy movement ---
const SPEED = 20
const CHANGE_DIRECTION_INTERVAL = 1.5
const PAUSE_CHANCE = 0.2  # chance to pause instead of moving

# --- State ---
var direction = Vector2.ZERO
var change_dir_timer = 0.0

# --- NODES (optional: animation) ---
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	add_to_group("enemies")
	_pick_new_direction()

func _physics_process(delta):
	# --- KNOCKBACK OVERRIDES MOVEMENT ---
	if knockback_velocity.length() > 0.1:
		velocity = knockback_velocity
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_DECAY)
		return

	# --- RANDOM WALK LOGIC ---
	change_dir_timer -= delta
	if change_dir_timer <= 0:
		_pick_new_direction()

	velocity = direction * SPEED
	move_and_slide()

	# --- OPTIONAL: Animation ---
	if anim:
		if direction == Vector2.ZERO:
			anim.play("idle")
		else:
			if abs(direction.x) > abs(direction.y):
				anim.play("walk_right" if direction.x > 0 else "walk_left")
			else:
				anim.play("walk_down" if direction.y > 0 else "walk_up")

# --- RANDOM DIRECTION PICKER ---
func _pick_new_direction():
	change_dir_timer = CHANGE_DIRECTION_INTERVAL + randf_range(-0.5, 0.5)
	if randf() < PAUSE_CHANCE:
		direction = Vector2.ZERO
	else:
		var dirs = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
		direction = dirs[randi() % dirs.size()]

# --- KNOCKBACK ---
func apply_knockback(dir: Vector2):
	knockback_velocity = dir * KNOCKBACK_FORCE

# --- DAMAGE HANDLING ---
func take_damage(amount: int):
	# Optional: knockback away from player or attack source
	apply_knockback(Vector2(0,1))
	health -= amount
	print("Damage taken. HP left:", health)
	if health <= 0:
		queue_free()
