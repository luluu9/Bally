extends KinematicBody2D

var speed = 200
var velocity = Vector2()


func _ready():
	randomize()
	velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	velocity *= speed


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	print(collision)
	if collision:
	    var reflect = collision.remainder.bounce(collision.normal)
	    velocity = velocity.bounce(collision.normal)
	    move_and_collide(reflect)
