extends Node

#Player ref.
@onready var parent: CharacterBody3D = $".."
#Velocity
var delta: float
var velocity: Vector3 = Vector3.ZERO
@export var base_acceleration: float = 10.0
var acceleration: float
#Inputs
var direction: Vector3
#Speeds
var speed
@export var walk_speed : float = 10.0
@export var sprint_speed : float = 20.0
@export var crouch_speed : float = 5.0
@export var jump_power : float = 10.0
#Gravity
var gravity : Variant = ProjectSettings.get_setting("physics/3d/default_gravity")
#Booleans
var ground_check: bool = false
var is_crouching: bool = false
var is_sprinting: bool = false
var jump_pressed: bool = false
var ballsinger: float

func _ready() -> void:
	speed = walk_speed
	ballsinger = gravity

#Connecting inputs from Player
func set_direction(value: Vector3):
	direction = value

func set_is_on_floor(value: bool):
	ground_check = value

func set_jump_pressed(value: bool):
	jump_pressed = value

func set_crouch(value: bool):
	is_crouching = value

func set_sprint(value: bool):
	is_sprinting = value

func set_delta(value: float):
	delta = value

func process_movement():
	#State check
	if is_crouching:
		speed = crouch_speed
		acceleration = base_acceleration * 0.5
	elif is_sprinting:
		speed = sprint_speed
		acceleration = base_acceleration * 1.5
	else:
		speed = walk_speed
		acceleration = base_acceleration

	#Jump
	if jump_pressed and ground_check:
		velocity.y = jump_power
	#Gravity
	if not ground_check:
		velocity.y -= gravity * delta
	#Movement depending on direction
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		velocity.z = move_toward(velocity.z, 0, acceleration * delta)
	

func get_velocity():
	return velocity
	
