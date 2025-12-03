extends Node3D

@onready var spawner_interval: Timer = $"../SpawnerInterval"
@onready var deer_blueprint: Resource = preload("uid://01dw3ve3er7y")
@export var deer_count: int = 3


func _on_spawner_interval_timeout() -> void:
	pass

func _spawn_deer(amount: int, spawn_pos: Vector3):
	for i in range(deer_count):
		pass
