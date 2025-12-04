extends CharacterBody3D

@onready var moveInterval: Timer = $MoveInterval
@onready var navAgent: NavigationAgent3D = $NavigationAgent3D
@export var speed: float
var random_position

func _ready() -> void:
	randomize()

func _on_move_interval_timeout() -> void:
	var radius = 25.0
	var angle = randf_range(0, PI * 2)
	var distance = randf_range(0, radius)
	random_position = global_position + Vector3(cos(angle) * distance, 0, sin(angle) * distance)
	navAgent.set_target_position(random_position)
	

func rotate_toward_target(target: Vector3, delta: float) -> void:
	var direction = (target - global_position).normalized()
	direction.y = 0
	if direction.length_squared() == 0:
		return
	var target_rotation = Transform3D().looking_at(direction, Vector3.UP).basis.get_euler()
	var current_rotation = rotation
	rotation.y = lerp_angle(current_rotation.y, target_rotation.y, delta * 3)

func move():
	pass
	
	
func _physics_process(delta: float) -> void:
	#global_translate(Vector3(0, -0.05, 0))
	if not is_on_floor():
		velocity.y -= 9.81 * delta
	else:
		velocity.y = 0
	var destination = navAgent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()
	
	rotate_toward_target(destination, delta)


func _on_navigation_agent_3d_target_reached() -> void:
	moveInterval.start()
