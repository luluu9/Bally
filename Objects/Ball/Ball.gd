extends KinematicBody2D
class_name Ball

var speed = 500
var velocity = Vector2()

var start_position = Vector2(960, 540)

puppet var remote_position = Vector2()

var goalscorer = null

func _ready():
	randomize()
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	velocity *= speed
	position = start_position
	goalscorer = null
#	if not get_tree().get_network_peer():
#		offline = true


func _physics_process(delta):
	if is_network_master():
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider_parent = collision.collider.get_parent()
			if collider_parent.has_method("set_points"):
				goalscorer = collider_parent
#			this gave me an error, I think it's bug:
#			if collider_parent is Player:
#				goalscorer = collider_parent
			velocity = velocity.bounce(collision.normal)
		rset_unreliable("remote_position", self.position)
	else:
		self.position = remote_position
