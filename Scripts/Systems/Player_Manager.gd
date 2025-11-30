extends CharacterBody3D


#CHARACTER REFERENCES
@export var animplayer: AnimationPlayer
@export var collision: CollisionShape3D
@export var movement_component: Node3D
#MOVEMENT VALUES
#@export var toggle_crouch_button: bool = true
var is_crouching: bool = false
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
	movement_component.set_jump_pressed(Input.is_action_just_pressed("Jump"))

func _unhandled_input(event):
	#CAMERA ROTATION WITH HEAD/WHOLE CHARACTER MOVEMENT
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _ready():
	#GET MOUSE POS
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var input_vector = -Input.get_vector("Left", "Right", "Forward", "Backward")
	var world_direction = (head.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	movement_component.set_direction(world_direction)
	movement_component.set_is_on_floor(is_on_floor())
	movement_component.set_crouch(Input.is_action_pressed("Crouch"))
	movement_component.set_sprint(Input.is_action_pressed("Sprint"))
	movement_component.set_delta(delta)
	movement_component.process_movement()
	velocity = movement_component.get_velocity()
	#BOB VALUES
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	#FOV CHANGE
	#var velocity_clamped = clamp(velocity.length(), 0.5, sprint_move_speed * 2)
	#var target_fov = base_fov + fov_change * velocity_clamped
	#camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	move_and_slide()

func _headbob(time) -> Vector3:
	#HEAD MOVEMENT
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos

func crouch(state: bool):
	match state:
		true:
			animplayer.play("Crouch")
		false:
			animplayer.play_backwards("Crouch")
