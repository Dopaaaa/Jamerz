extends CharacterBody2D

# Variables
@export var speed = 200
@export var jump_force = -400
@export var gravity = 800
@export var attack_cooldown = 0.5
@export var can_attack = true
@export var health = 100
@onready var animated_sprite_2d = $AnimatedSprite2D
var is_walking := false
var is_attacking := false

# Functions
func _ready():
	pass

func _physics_process(delta):
	#Combat
	if Input.is_action_just_pressed("weak_attack"):
		is_attacking = true
		animated_sprite_2d.play("weak_attack")
	elif Input.is_action_just_pressed("strong_attack"):
		is_attacking = true
		animated_sprite_2d.play("strong_attack")	
		
	# Movement
	elif Input.is_action_pressed("move_left") && is_attacking == false:
		is_walking = true
		velocity.x = -speed
		animated_sprite_2d.play("walk")
		animated_sprite_2d.flip_h = true
	elif Input.is_action_pressed("move_right") && is_attacking == false:
		is_walking = true
		velocity.x = speed
		animated_sprite_2d.play("walk")
		animated_sprite_2d.flip_h = false
	else:
		is_attacking = false
		is_walking = false
		velocity.x = 0
		animated_sprite_2d.play("idle")
	
	
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


func _on_animated_sprite_2d_animation_finished():
	#if animated_sprite_2d.animation == "walk":
		#animated_sprite_2d.play("transition_TO_idle")
	if animated_sprite_2d.animation == "transition_TO_idle":
		animated_sprite_2d.play("idle")


func _on_timer_timeout():
	pass # Replace with function body.
