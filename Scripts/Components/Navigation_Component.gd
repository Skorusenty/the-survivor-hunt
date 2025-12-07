# Handles pathfinding and movement - reusable for all animals
extends Node
class_name NavigationComponent

@export var speed: float = 3.0
@export var rotation_speed: float = 3.0

var nav_agent: NavigationAgent3D
var character: CharacterBody3D
var timer: Timer
func _ready() -> void:
	# Get references from parent
	character = get_parent() as CharacterBody3D
	nav_agent = character.get_node("NavigationAgent3D")
	timer = character.get_node("MoveInterval")

func move_to(target_position: Vector3) -> void:
	nav_agent.set_target_position(target_position)

func physics_process(delta: float) -> void:
	if not character.is_on_floor():
		character.velocity.y -= 9.81 * delta
	else:
		character.velocity.y = 0
	
	# Only move if we have a valid path
	if not nav_agent.is_navigation_finished():
		var destination = nav_agent.get_next_path_position()
		var local_destination = destination - character.global_position
		var direction = local_destination.normalized()
		
		character.velocity.x = direction.x * speed
		character.velocity.z = direction.z * speed
		
		rotate_toward_target(destination, delta)
	else:
		# Gradually stop
		character.velocity.x = 0
		character.velocity.z = 0

	character.move_and_slide()

func rotate_toward_target(target: Vector3, delta: float) -> void:
	var direction = (target - character.global_position).normalized()
	direction.y = 0
	
	if direction.length_squared() == 0:
		return
	
	var target_rotation = Transform3D().looking_at(direction, Vector3.UP).basis.get_euler()
	var current_rotation = character.rotation
	character.rotation.y = lerp_angle(current_rotation.y, target_rotation.y, delta * rotation_speed)

func is_at_target() -> bool:
	return nav_agent.is_navigation_finished()

func stop() -> void:
	character.velocity = Vector3.ZERO
