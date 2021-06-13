extends KinematicBody2D
class_name Ball

var speed = 500
var velocity = Vector2()

var start_position = Vector2(960, 540)
var radius = 0
var max_bounce_angle = 60
onready var tween = $Tween

puppet var remote_position = Vector2() setget remote_position_set
puppet var remote_velocity = Vector2()

var goalscorer = null


func _ready():
	randomize()
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	velocity *= speed
	position = start_position
	goalscorer = null
	radius = $CollisionShape2D.shape.radius*self.scale.x
#	if not get_tree().get_network_peer():
#		offline = true


func _physics_process(delta):
	if is_network_master():
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider_parent = collision.collider.get_parent()
			if collider_parent.has_method("set_points"):
				goalscorer = collider_parent
				var paddle = collision.collider
				var angle = max_bounce_angle / (paddle.length + radius) * (self.global_position.y - paddle.global_position.y) 
				angle = clamp(angle, -max_bounce_angle, max_bounce_angle)
				velocity = collision.normal.rotated(deg2rad(angle)) * speed
			else:
				velocity = velocity.bounce(collision.normal)
		rset_unreliable("remote_position", position)
		rset_unreliable("remote_velocity", velocity)
	else:
		if not tween.is_active():
			# warning-ignore:return_value_discarded
			move_and_collide(remote_velocity * delta)


# https://www.youtube.com/watch?v=fE6GNBkeey8&t=581s
func remote_position_set(new_position):
	remote_position = new_position
	tween.interpolate_property(self, "position", position, remote_position, 1/60)
	tween.start()


func _input(_event):
	if get_tree().is_network_server():
		if Input.is_action_pressed("restart"):
			self._ready()
