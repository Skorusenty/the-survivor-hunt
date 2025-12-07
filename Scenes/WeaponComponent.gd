extends Node3D

@export var bullet_scene: PackedScene
@export var fire_rate = 0.2
@onready var camera = $Camera3D
@onready var muzzle = $Camera3D/WeaponHolder/Muzzle  # Marker3D for spawn point

var can_shoot = true

func _process(_delta):
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	can_shoot = false
	
	# Instantiate bullet
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	
	# Position at muzzle
	bullet.global_position = muzzle.global_position
	
	# Set direction (camera forward)
	bullet.direction = -camera.global_transform.basis.z
	
	# Optional: match muzzle rotation
	bullet.global_rotation = muzzle.global_rotation
	
	# Fire rate cooldown
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
