extends Control

signal start_game

onready var logs = $HBoxContainer/ConnectionLog
onready var start_button = $HBoxContainer/VBoxContainer/StartButton


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func log_message(message):
	logs.add_text(message)
	logs.newline()


func start():
	if get_tree().is_network_server():
		var message = "Hosting, id " + str(get_tree().get_network_unique_id())
		log_message(message)
		start_button.disabled = false
	else:
		var message = "Connecting as peer, id " + str(get_tree().get_network_unique_id())
		log_message(message)


func _player_connected(id):
	var message = "Player connected, id " + str(id)
	log_message(message)


func _player_disconnected(id):
	var message = "Player disconnected, id " + str(id)
	log_message(message)


func _connected_ok():
	var message = "Connected"
	log_message(message)


func _connection_fail():
	var message = "Connection failed"
	log_message(message)


func _server_disconnected():
	var message = "Server disconnected"
	log_message(message)


func _on_StartButton_pressed():
	Singleton.get_networking_node().prepare_game()
	Singleton.get_networking_node().rpc('prepare_game')
	emit_signal("start_game")

