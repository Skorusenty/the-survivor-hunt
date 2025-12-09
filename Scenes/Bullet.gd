extends RigidBody3D

var speed = 250.0
var direction = Vector3.FORWARD


func _ready():
	# Apply initial velocity
	linear_velocity = -direction * speed
	
	# Auto-destroy after 5 seconds
	get_tree().create_timer(5.0).timeout.connect(queue_free)

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free()
