extends Node

onready var ball = $Ball
onready var world = $World

onready var player_scene = load("res://Objects/Player/Player.tscn")

const test_players = 6


func _ready():
	var server = NetworkedMultiplayerENet.new()
	server.create_server(11111, 1)
	get_tree().network_peer = server
#	ball.start_position = Vector2(200, 200)
#	ball.position = Vector2(200, 200)
	world.prepare(test_players)
	var player_names = []
	for i in range(1, test_players+1):
		player_names.append(i)
	for i in range(1, test_players+1):
		var player = player_scene.instance()
		player.name = str(i)
		player.set_network_master(i) 
		world.add_child(player, player_names)
	
	
