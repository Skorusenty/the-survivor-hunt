extends Node

#Player ref.
@onready var player: CharacterBody3D = $".."
#Velocity
var velocity: Vector3 = Vector3.ZERO
#Inputs
var move_input: Vector2 = Vector2.ZERO
#Speeds
@export var walk_speed : float = 10
@export var sprint_speed : float = 20
@export var crouch_speed : float = 5
#Gravity
var gravity : Variant = ProjectSettings.get_setting("physics/3d/default_gravity")
#Booleans
var is_crouching: bool = false
var is_sprinting: bool = false
