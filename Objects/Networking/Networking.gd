extends Node

signal connected
signal hosted
signal started
signal lost_connection

var SERVER_PORT = 6996
var MAX_PLAYERS = 8

var players = []
# players_info eg.:
# - id: [['color': Color], ['name': Name]]
var players_info = {}
var players_ready = []

var player_scene = load("res://Objects/Player/Player.tscn")
var ball_scene = load("res://Objects/Ball/Ball.tscn")
onready var world = get_node("/root/Game/World")


func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	# get_tree().connect("connected_to_server", self, "_connected_ok")
	# get_tree().connect("connection_failed", self, "_connected_fail")
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func _player_connected(id):
	rpc_id(id, "register_player")
	if get_tree().is_network_server():
		rpc_id(id, "set_info", players_info)


func _player_disconnected(id):
	id = str(id)
	if id in players_ready: 
		world.get_node(id).queue_free()
	Singleton.get_lobby_screen().remove_player(id)
	if id in players:
		players.erase(id)
	if id in players_info:
		players_info.erase(id)


func _server_disconnected():
	get_tree().set_pause(true)
	for node in world.get_children():
		if node.name != "Borders":
			node.queue_free()
	players.clear()
	players_info.clear()
	players_ready.clear()
	emit_signal("lost_connection")
	get_tree().set_pause(false)


# called on connected player
remote func register_player():
	var id = str(get_tree().get_rpc_sender_id())
	players.append(id)


remote func player_ready(id):
	players_ready.append(id)
	if len(players_ready) == len(players):
		rpc("start_game")
		start_game()


remote func prepare_game():
	prepare_world()
	initialize_players()
	if not get_tree().is_network_server():
		rpc_id(1, "player_ready", str(get_tree().get_network_unique_id()))
	if len(players) > 0:
		get_tree().set_pause(true)


remote func start_game():
	emit_signal("started")
	get_tree().set_pause(false)


func prepare_world():
	var ball = ball_scene.instance()
	ball.set_network_master(1)
	world.add_child(ball)


func initialize_players():
	var my_peer_id = str(get_tree().get_network_unique_id())
	add_player(my_peer_id)
	for player in players:
		add_player(player)


func add_player(peer_id):
	var player = player_scene.instance()
	player.set_name(peer_id)
	player.set_network_master(int(peer_id)) 
	if peer_id in players_info:
		for info_name in players_info[peer_id]:
			var info_value = players_info[peer_id][info_name]
			match info_name:
				"color":
					player.modulate = info_value
				"name":
					player.nickname = info_value
	world.add_child(player)


func _on_TitleScreen_host():
	var server = NetworkedMultiplayerENet.new()
	server.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = server
	emit_signal("hosted")


func _on_ConnectScreen_connect(ip, port):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().network_peer = peer
	emit_signal("connected")


func _on_LobbyScreen_start_game():
	rpc("prepare_game")
	prepare_game()


func _on_LobbyScreen_set_info(info):
	rpc("set_info", info)
	set_info(info)


remote func set_info(info):
	var id = str(get_tree().get_rpc_sender_id())
	if int(id) == 0: # it means that function is called as local 
		id = str(get_tree().get_network_unique_id())
	if info is Dictionary: # then it's whole story about player from host
		players_info = info
	else:
		var info_name = info[0]
		var info_value = info[1]
		if not id in players_info: 
			players_info[id] = {}
		players_info[id][info_name] = info_value
	Singleton.get_lobby_screen().update_lobby(players_info)
