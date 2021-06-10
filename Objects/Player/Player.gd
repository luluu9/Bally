extends Node2D
class_name Player

var paddle = null
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var nickname = ""

remotesync var points = 0 setget set_points
puppet var remote_position = Vector2()


func _ready():
	paddle = get_node("Paddle")


func rotate(new_rotation):
	up = up.rotated(new_rotation)
	down = down.rotated(new_rotation)
	.rotate(new_rotation)


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


func _on_Goal_body_entered(body):
	if get_tree().is_network_server():
		if body is Ball:
			if body.goalscorer:
				body.goalscorer.rset("points", body.goalscorer.points+1)
			body._ready()


func set_points(new_points):
	points = new_points
	if get_tree().get_network_unique_id() == int(self.name):
		Singleton.get_score_node().text = str(new_points)
