extends Node2D

var paddle = null
var up = Vector2(0, -1)
var down = Vector2(0, 1)


func _ready():
	paddle = get_node("Paddle")


func _physics_process(_delta):
	if not paddle:
		return
	if Input.is_action_pressed("move_up"):
		paddle.move(up)
	if Input.is_action_pressed("move_down"):
		paddle.move(down)
