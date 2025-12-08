extends Node3D

@onready var spawner_interval: Timer = $"../SpawnerInterval"
@onready var deer_blueprint: Resource = preload("uid://01dw3ve3er7y")
@export var deer_count: int = 3
var random_position: Vector3

func _ready() -> void:
	_spawn_deer(deer_count, random_position)

func _on_spawner_interval_timeout() -> void:
	_spawn_deer(5, random_position)

func _spawn_deer(amount: int, _random_position: Vector3):
	for i in range(amount):
		random_position = Vector3.ZERO
		random_position.x = randf_range(-400, 380)
		random_position.z = randf_range(-310, 430)
		var deer = deer_blueprint.instantiate()
		deer.position = random_position
		add_child(deer)
