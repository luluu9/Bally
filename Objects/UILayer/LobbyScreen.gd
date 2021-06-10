extends Control

signal start_game
signal set_info (info)

onready var logs = $HBoxContainer/ConnectionLog
onready var start_button = $HBoxContainer/VBoxContainer/StartButton
onready var color_picker = $HBoxContainer/VBoxContainer/ColorPicker
onready var players_node = $HBoxContainer/LobbyPlayers

onready var lobby_font = preload("res://Fonts/LobbyScreen.tres")


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


# currently doesn't delete disconnected players
func update_lobby(players_info):
	for peer_id in players_info:
		peer_id = str(peer_id)
		var player_label = players_node.get_node(peer_id) # throws error but works
		var player_color = players_node.get_node(peer_id + "_color")
		for info in players_info[int(peer_id)]:
			var info_name = info[0]
			var info_value = info[1]
			if not player_label: # player is new, create scenes
				player_label = Label.new()
				player_label.name = peer_id
				player_label.size_flags_horizontal = SIZE_EXPAND_FILL
				player_label.add_font_override("font", lobby_font)
				
				player_color = ColorRect.new()
				player_color.name = peer_id + "_color"
				player_color.size_flags_horizontal = SIZE_EXPAND_FILL
				
				players_node.add_child(player_label) 
				players_node.add_child(player_color)
			
			match info_name:
				"color":
					player_color.color = info_value
				"name": # not implemented now
					player_label.text = info_value 
