extends CharacterBody2D

# Variables
@export var speed = 200
@export var jump_force = -400
@export var gravity = 800
@export var attack_cooldown = 0.5
@export var can_attack = true
@export var health = 100
@onready var sprite_2d = $Sprite2D

# Functions
func _ready():
	pass

func _physics_process(delta):
	# Movement
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
		sprite_2d.flip_h = false
	else:
		velocity.x = 0
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
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
