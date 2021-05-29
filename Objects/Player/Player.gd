extends Node2D
class_name Player

var paddle = null
var up = Vector2(0, -1)
var down = Vector2(0, 1)
remotesync var points = 0

puppet var remote_position = Vector2()


func _ready():
	paddle = get_node("Paddle")


func _physics_process(_delta):
	if not paddle:
		return
	if is_network_master():
		if Input.is_action_pressed("move_up"):
			paddle.move(up)
		if Input.is_action_pressed("move_down"):
			paddle.move(down)
		
		rset_unreliable("remote_position", paddle.position)
	else:
		paddle.position = remote_position
	if get_tree().is_network_server():
		if Input.is_action_pressed("restart"):
			get_node("/root/Game/World/Ball")._ready()


func _on_Goal_body_entered(body):
	print(body.name)
	if body is Ball:
		if get_tree().is_network_server():
			rset("points", points+1)
			body._ready()
		print(points)
