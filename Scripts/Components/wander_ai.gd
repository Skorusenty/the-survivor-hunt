# Specific AI behavior - wandering randomly
# Other animals can use FleeAI, HuntAI, etc.
extends Node
class_name WanderAI

@export var wander_radius: float = 25.0
@export var wait_time_min: float = 2.0
@export var wait_time_max: float = 5.0

var navigation: NavigationComponent
var character: CharacterBody3D
var timer: Timer

func _ready() -> void:
	character = get_parent() as CharacterBody3D
	navigation = character.get_node("NavigationComponent")
	
	# Create timer
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	# Start wandering
	_pick_new_destination()

func _on_timer_timeout() -> void:
	_pick_new_destination()

func _pick_new_destination() -> void:
	# Pick random position within radius
	var angle = randf_range(0, PI * 2)
	var distance = randf_range(0, wander_radius)
	var random_position = character.global_position + Vector3(
		cos(angle) * distance,
		0,
		sin(angle) * distance
	)
	
	navigation.move_to(random_position)

func _physics_process(_delta: float) -> void:
	# When we reach destination, start timer
	if navigation.is_at_target() and timer.is_stopped():
		var wait_time = randf_range(wait_time_min, wait_time_max)
		timer.start(wait_time)
