extends KinematicBody2D
class_name Ball

var speed = 500
var velocity = Vector2()

puppet var remote_position = Vector2()


func _ready():
	randomize()
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	velocity *= speed
	position = Vector2(rand_range(960-400, 960+400), rand_range(540-200, 540+200))


func _physics_process(delta):
	if is_network_master():
		var collision = move_and_collide(velocity * delta)
		if collision:
		    var reflect = collision.remainder.bounce(collision.normal)
		    velocity = velocity.bounce(collision.normal)
			# warning-ignore:return_value_discarded
		    move_and_collide(reflect)
		rset_unreliable("remote_position", self.position)
	else:
		self.position = remote_position
