
extends CharacterBody3D

@onready var navigation: NavigationComponent = $NavigationComponent
@onready var ai: Node = $WanderAI  # Could be WanderAI, FleeAI, HuntAI, etc.

func _physics_process(delta: float) -> void:
	# Let navigation component handle all movement
	navigation.physics_process(delta)
