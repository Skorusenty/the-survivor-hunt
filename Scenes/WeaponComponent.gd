extends Node3D
class_name WeaponComponent

## Signals
signal shot_fired(position: Vector3, direction: Vector3)
signal ammo_changed(current: int, max: int)
signal reload_started()
signal reload_finished()

## Weapon Stats
@export_group("Weapon Properties")
@export var weapon_name: String = "Weapon"
@export var damage: float = 10.0
@export var fire_rate: float = 0.2  # Time between shots
@export var bullet_speed: float = 50.0
@export var max_range: float = 1000.0

## Projectile/Hitscan
@export_group("Projectile Settings")
@export var use_projectile: bool = true  # false = hitscan
@export var bullet_scene: PackedScene
<<<<<<< Updated upstream
@export var fire_rate = 0.2
@onready var camera = get_parent()
@onready var muzzle = $Muzzle
=======
>>>>>>> Stashed changes

## Ammo System
@export_group("Ammo")
@export var use_ammo: bool = false
@export var magazine_size: int = 30
@export var max_ammo: int = 120
@export var reload_time: float = 2.0
@export var auto_reload: bool = true

## References
@export_group("References")
@export var camera: Camera3D
@export var muzzle: Marker3D

## Internal State
var can_shoot: bool = true
var is_reloading: bool = false
var current_ammo: int
var reserve_ammo: int

func _ready():
	if use_ammo:
		current_ammo = magazine_size
		reserve_ammo = max_ammo
		ammo_changed.emit(current_ammo, magazine_size)
	
	# Auto-find camera if not set
	if not camera:
		camera = get_viewport().get_camera_3d()
	
	# Auto-find muzzle if not set
	if not muzzle:
		muzzle = get_node_or_null("Muzzle")

func _process(_delta):
	if Input.is_action_pressed("Shoot") and can_fire():
		shoot()
	
	if Input.is_action_just_pressed("Reload") and can_reload():
		reload()

## Main shooting function
func shoot() -> void:
	if not can_fire():
		if auto_reload and use_ammo and current_ammo <= 0 and can_reload():
			reload()
		return
	
	can_shoot = false
	
	# Consume ammo
	if use_ammo:
		current_ammo -= 1
		ammo_changed.emit(current_ammo, magazine_size)
	
	# Fire projectile or hitscan
	if use_projectile:
		fire_projectile()
	else:
		fire_hitscan()
	
<<<<<<< Updated upstream
	# Set direction (camera forward)
	bullet.direction = camera.global_transform.basis.z
	
	# Optional: match muzzle rotation
	bullet.global_rotation = muzzle.global_rotation
=======
	# Emit signal for effects (muzzle flash, sound, etc.)
	var shoot_pos = muzzle.global_position if muzzle else global_position
	var shoot_dir = get_shoot_direction()
	shot_fired.emit(shoot_pos, shoot_dir)
>>>>>>> Stashed changes
	
	# Fire rate cooldown
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

## Projectile shooting
func fire_projectile() -> void:
	if not bullet_scene:
		push_error("No bullet scene assigned to weapon!")
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	
	# Position
	if muzzle:
		bullet.global_position = muzzle.global_position
		bullet.global_rotation = muzzle.global_rotation
	else:
		bullet.global_position = global_position
	
	# Set properties if bullet has them
	if bullet.has("direction"):
		bullet.direction = get_shoot_direction()
	if bullet.has("speed"):
		bullet.speed = bullet_speed
	if bullet.has("damage"):
		bullet.damage = damage

## Hitscan shooting
func fire_hitscan() -> void:
	if not camera:
		push_error("No camera assigned for hitscan!")
		return
	
	var from = camera.global_position
	var direction = get_shoot_direction()
	var to = from + direction * max_range
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	# Exclude the weapon's owner
	if get_parent():
		query.exclude = [get_parent()]
	
	var result = space_state.intersect_ray(query)
	
	if result:
		# Apply damage
		if result.collider.has_method("take_damage"):
			result.collider.take_damage(damage)
		
		# Could spawn impact effect at result.position
		spawn_impact_effect(result.position, result.normal)

## Get shooting direction
func get_shoot_direction() -> Vector3:
	if camera:
		return -camera.global_transform.basis.z
	elif muzzle:
		return -muzzle.global_transform.basis.z
	else:
		return -global_transform.basis.z

## Reload system
func reload() -> void:
	if not can_reload():
		return
	
	is_reloading = true
	can_shoot = false
	reload_started.emit()
	
	await get_tree().create_timer(reload_time).timeout
	
	if use_ammo:
		var ammo_needed = magazine_size - current_ammo
		var ammo_to_reload = min(ammo_needed, reserve_ammo)
		
		current_ammo += ammo_to_reload
		reserve_ammo -= ammo_to_reload
		
		ammo_changed.emit(current_ammo, magazine_size)
	
	is_reloading = false
	can_shoot = true
	reload_finished.emit()

## Utility functions
func can_fire() -> bool:
	if not can_shoot or is_reloading:
		return false
	if use_ammo and current_ammo <= 0:
		return false
	return true

func can_reload() -> bool:
	if not use_ammo:
		return false
	if is_reloading:
		return false
	if current_ammo >= magazine_size:
		return false
	if reserve_ammo <= 0:
		return false
	return true

func add_ammo(amount: int) -> void:
	if use_ammo:
		reserve_ammo = min(reserve_ammo + amount, max_ammo)
		ammo_changed.emit(current_ammo, magazine_size)

func spawn_impact_effect(position: Vector3, normal: Vector3) -> void:
	# Override this or connect to shot_fired signal
	# to spawn bullet holes, particles, etc.
	pass

## Getters
func get_ammo_percentage() -> float:
	if not use_ammo or magazine_size == 0:
		return 100.0
	return (float(current_ammo) / float(magazine_size)) * 100.0
