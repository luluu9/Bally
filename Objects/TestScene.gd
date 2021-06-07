extends Node

onready var ball = $Ball

func _ready():
	var server = NetworkedMultiplayerENet.new()
	server.create_server(11111, 1)
	get_tree().network_peer = server
	ball.position = Vector2(200, 200)
