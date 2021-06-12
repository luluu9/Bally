extends Node2D
class_name Player

var up = Vector2(0, -1)
var down = Vector2(0, 1)
var nickname = ""
onready var paddle = $Paddle
onready var tween = $Tween

remotesync var points = 0 setget set_points
puppet var remote_position = Vector2() setget remote_position_set
puppet var remote_direction = Vector2()


func rotate(new_rotation):
	up = up.rotated(new_rotation)
	down = down.rotated(new_rotation)
	.rotate(new_rotation)


func _physics_process(_delta):
	if not paddle:
		return
	if is_network_master():
		var direction = Vector2(0, 0)
		if Input.is_action_pressed("move_up"):
			direction = up
		if Input.is_action_pressed("move_down"):
			direction = down
		paddle.move(direction)
		
		rset_unreliable("remote_direction", direction)
		rset_unreliable("remote_position", paddle.position)
	else:
		if not tween.is_active():
			paddle.move(remote_direction)


func _on_Goal_body_entered(body):
	if get_tree().is_network_server():
		if body is Ball:
			if body.goalscorer:
				body.goalscorer.rset("points", body.goalscorer.points+1)
			body._ready()


func set_points(new_points):
	points = new_points
	if get_tree().get_network_unique_id() == int(self.name):
		var score_node = Singleton.get_score_node()
		if score_node:
			score_node.text = str(new_points)


func remote_position_set(new_position):
	remote_position = new_position
	tween.interpolate_property(paddle, "position", position, remote_position, 1/10)
	tween.start()
