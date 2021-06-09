extends KinematicBody2D

var speed = 500
var length = 0


func _ready():
	length = $CollisionShape2D.shape.extents.y


func move(direction):
	var delta = get_physics_process_delta_time()
	var velocity = direction * speed * delta
	# warning-ignore:return_value_discarded
	move_and_collide(velocity)
