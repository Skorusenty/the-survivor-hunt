extends Node3D

@export var yaw_owner: Node3D
@export var pitch_owner: Node3D
@export var sensitivity: float = 0.03	
var pitch_min: float = deg_to_rad(-85.0)
var pitch_max: float = deg_to_rad(85.0)
var delta: float

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func update_camera(mouse_delta):
	var scaled_delta: Vector2 = mouse_delta * 0.2
	yaw_owner.rotate_y(-scaled_delta.x * sensitivity * delta * 60)
	pitch_owner.rotate_x(scaled_delta.y * sensitivity * delta * 60)
	pitch_owner.rotation.x = clamp(pitch_owner.rotation.x, pitch_min, pitch_max)

func set_delta(value):
	delta = value

func get_head():
	return pitch_owner

func get_cam():
	return yaw_owner
