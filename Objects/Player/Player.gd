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

	var state = get_state()
	if get_tree().is_network_server():
		Singleton.get_networking_node().update_state(state)
	else:
		Singleton.get_networking_node().rpc_unreliable_id(1, 'update_state', state)

func get_state():
	var time = OS.get_ticks_usec()
	var info = paddle.position
	var state = {
		"name": name,
		"time": time,
		"info": info
		}
	return state
