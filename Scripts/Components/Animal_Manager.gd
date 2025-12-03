extends CharacterBody3D

@onready var moveInterval: Timer = $MoveInterval
@onready var navAgent: NavigationAgent3D = $NavigationAgent3D
@export var speed: float
var random_position

func _ready() -> void:
	randomize()

func _on_move_interval_timeout() -> void:
	random_position = Vector3.ZERO
	random_position.x = randf_range(-25, 25)
	random_position.z = randf_range(-25, 25)
	navAgent.set_target_position(random_position)
	move()
	
func move():
	pass
	
	
func _physics_process(delta: float) -> void:
	velocity.y -= 9.8 * delta
	var destination = navAgent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = direction * speed
	move_and_slide()
