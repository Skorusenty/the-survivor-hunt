extends CharacterBody3D


#CHARACTER REFERENCES
@export var animplayer: AnimationPlayer
@export var collision: CollisionShape3D
@export var movement_component: Node3D
#MOVEMENT VALUES
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed
const default_move_speed = 3
const sprint_move_speed = 5
const jump_speed = 3
const crouch_move_speed = 1
const crouch_speed = 20
var is_crouching: bool = false
@export var toggle_crouch_button: bool = true
#BOB VALUES
const bob_freq = 2.0
const bob_amp = 0.08
var t_bob = 0.0

#FOV VALUES
const base_fov = 75.0
const fov_change = 1.5

#CAMERA REFERENCES AND VALUES
@export var sensitivity = 0.003
@onready var head = $Head
@onready var camera = $Head/Camera3D


func _input(event):
	if event.is_action_pressed("Exit"):
		get_tree().quit()
	if event.is_action_pressed("Crouch"):
		toggle_crouch()

func _unhandled_input(event):
	
	#CAMERA ROTATION WITH HEAD/WHOLE CHARACTER MOVEMENT
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _ready():

	#GET MOUSE POS
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	speed = default_move_speed

func _physics_process(delta):
	#GRAVITY
	if not is_on_floor():
		velocity.y -= gravity * delta

	#JUMP
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_speed

	#MOVEMENT
	var input_vector = -Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (head.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	movement_component.set_input(input_vector)
	velocity = movement_component.get_velocity()
	#if direction:
		#velocity.x = direction.x * speed
		#velocity.z = direction.z * speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, default_move_speed)
		#velocity.z = move_toward(velocity.z, 0, default_move_speed)

	#BOB VALUES
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	#SPRINT
	if Input.is_action_pressed("Sprint") and is_crouching == false:
		movement_speed("Sprint")

	#FOV CHANGE
	var velocity_clamped = clamp(velocity.length(), 0.5, sprint_move_speed * 2)
	var target_fov = base_fov + fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	move_and_slide()

func _headbob(time) -> Vector3:

	#HEAD MOVEMENT
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos

func toggle_crouch():

	#CROUCHING
		if is_crouching == true:
			crouch(false)
		elif is_crouching == false:
			crouch(true)
		is_crouching = !is_crouching

func crouch(state: bool):
	match state:
		true:
			animplayer.play("Crouch")
		false:
			animplayer.play_backwards("Crouch")


func movement_speed(state: String):
	match state:
		"Crouch":
			speed = crouch_move_speed
		"Default":
			speed = default_move_speed
		"Sprint":
			speed = sprint_move_speed
