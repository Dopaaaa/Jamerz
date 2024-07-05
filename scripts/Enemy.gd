extends CharacterBody2D

# Variables
@export var speed = 200
@export var jump_force = -400
@export var gravity = 800
@export var attack_cooldown = 0.5
@export var can_attack = true
@export var health = 100

# Functions
func _ready():
	pass

func _physics_process(delta):
	# Simple AI movement logic
	if position.x > 600:
		velocity.x = -speed
	elif position.x < 200:
		velocity.x = speed
	else:
		velocity.x = 0
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		if randf() < 0.1:
			velocity.y = jump_force
	
	move_and_slide()

func attack():
	can_attack = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()
