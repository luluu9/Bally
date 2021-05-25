extends Node

signal connected
signal hosted

var SERVER_PORT = 6996
var MAX_PLAYERS = 2

var players = []
var players_ready = []

var current_state = {}
# current _state:
# - player:
#   - time:
#   - position / move

var player_scene = load("res://Objects/Player/Player.tscn")
var remote_player_scene = load("res://Objects/Player/RemotePlayer.tscn")
# var world_scene = load("res://Objects/World/World.tscn")

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
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
		$StateProcessing.set_physics_process(true)


remote func prepare_game():
	prepare_world()
	initialize_players()
	rpc_id(1, "player_ready", get_tree().get_network_unique_id())
	get_tree().set_pause(true)


remote func start_game():
	get_tree().set_pause(false)


func prepare_world():
	var world = Node2D.new()
	world.name = "World"
	get_node("/root/Game").add_child(world)


func add_player(peer_id):
	var player = player_scene.instance()
	player.set_name(str(peer_id))
	player.set_network_master(peer_id) 
	player.position = Vector2(randi()%700, 100)
	get_node("/root/Game/World").add_child(player)


func add_remote_player(peer_id):
	var player = remote_player_scene.instance()
	player.set_name(str(peer_id))
	player.set_network_master(peer_id) 
	player.position = Vector2(randi()%700, 100)
	get_node("/root/Game/World").add_child(player)


func initialize_players():
	var my_peer_id = get_tree().get_network_unique_id()
	add_player(my_peer_id)
	var players = Singleton.get_networking_node().players
	for player in players:
		add_remote_player(player)


remote func update_state(state):
	var player = int(state["name"])
	var time = int(state["time"])
	var pos = Vector2(state["info"])
	# print(player, pos, time)
	if player in current_state: # existing player
		# time must be lower since we are using ticks since the engine started
		if current_state[player]["time"] > time: 
			return
	current_state[player] = {"time": time, "position": pos}
	# print(current_state)


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
