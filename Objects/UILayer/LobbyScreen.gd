extends Control

signal start_game
signal set_info (info)

onready var logs = $HBoxContainer/ConnectionLog
onready var start_button = $HBoxContainer/VBoxContainer/StartButton
onready var color_picker = $HBoxContainer/VBoxContainer/ColorPicker


func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_connected_ok")
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_connected_fail")
	# warning-ignore:return_value_discarded
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
	emit_signal("start_game")


func _on_SetButton_pressed():
	var color = color_picker.color
	var info = ["color", color]
	emit_signal("set_info", info)
	
