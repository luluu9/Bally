extends KinematicBody2D

var speed = 150


func move(direction):
	var delta = get_physics_process_delta_time()
	var velocity = direction * speed * delta
	move_and_collide(velocity)
