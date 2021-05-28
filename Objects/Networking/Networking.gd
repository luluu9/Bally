extends Node

signal connected
signal hosted

var SERVER_PORT = 6996
var MAX_PLAYERS = 1

var players = []
var players_ready = []


var player_scene = load("res://Objects/Player/Player.tscn")
# var world_scene = load("res://Objects/World/World.tscn")


func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	# get_tree().connect("connected_to_server", self, "_connected_ok")
	# get_tree().connect("connection_failed", self, "_connected_fail")
	# get_tree().connect("server_disconnected", self, "_server_disconnected")


func _player_connected(id):
	rpc_id(id, "register_player")


func _player_disconnected(id):
	rpc_id(id, "unregister_player")


remote func register_player():
	var id = get_tree().get_rpc_sender_id()
	players.append(id)


remote func unregister_player():
	var id = get_tree().get_rpc_sender_id()
	if id in players:
		players.erase(id)


remote func player_ready(id):
	players_ready.append(id)
	if len(players_ready) == len(players):
		rpc("start_game")
		start_game()


remote func prepare_game():
	prepare_world()
	initialize_players()
	if len(players) != 0: # if host is alone
		rpc_id(1, "player_ready", get_tree().get_network_unique_id())
		get_tree().set_pause(true)


remote func start_game():
	get_tree().set_pause(false)


func prepare_world():
	pass


func initialize_players():
	var my_peer_id = get_tree().get_network_unique_id()
	add_player(my_peer_id)
	for player in players:
		add_player(player)


func add_player(peer_id):
	var player = player_scene.instance()
	player.set_name(str(peer_id))
	player.set_network_master(peer_id) 
	get_node("/root/Game/World").add_child(player)


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