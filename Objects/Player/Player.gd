extends Node2D
class_name Player

var paddle = null
var up = Vector2(0, -1)
var down = Vector2(0, 1)

puppet var remote_position = Vector2()


func _ready():
	paddle = get_node("Paddle")


func _physics_process(_delta):
	if is_network_master():
		if not paddle:
			return
		if Input.is_action_pressed("move_up"):
			paddle.move(up)
		if Input.is_action_pressed("move_down"):
			paddle.move(down)
		
		rset_unreliable("remote_position", paddle.position)
	else:
		paddle.position = remote_position
