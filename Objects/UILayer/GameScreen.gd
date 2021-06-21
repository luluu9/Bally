extends Control

onready var players_node = $Players
onready var players_font = preload("res://Fonts/PlayersList.tres")

# players:
# - peer_id:
#   // all of these are nodes:
#   - "nickname"
#   - "color"
#   - "points"
var players = {}
var default_name = "Guest"
var default_color = Color(255, 255, 255)

#func _ready():
#	var players_info = {'1':{'color':Color(0.780398,0.132456,0.132456,1), 'name':'h'}}
#	initialize_players(players_info)


func update_score(peer_id, score):
	if peer_id in players:
		players[peer_id]['points'].text = score


func initialize_players(players_list, players_info):
	for peer_id in players_list:
		var nickname = default_name
		var color = default_color
		if peer_id in players_info:
			for info_name in players_info[peer_id]:
				var info_value = players_info[peer_id][info_name]
				match info_name:
					"color":
						color = info_value
					"name":
						nickname = info_value 
		add_player(peer_id, nickname, color)


func add_player(peer_id, nickname, color):
	var player = {}
	
	var nickname_label = Label.new()
	nickname_label.name = peer_id
	nickname_label.size_flags_horizontal = SIZE_EXPAND_FILL
	nickname_label.add_font_override("font", players_font)
	nickname_label.clip_text = true
	nickname_label.text = nickname
	player["nickname"] = nickname_label
	
	var player_color = ColorRect.new()
	player_color.name = peer_id + "_color"
	player_color.size_flags_horizontal = SIZE_EXPAND_FILL
	player_color.color = color
	player["color"] = player_color
	
	var points_label = Label.new()
	points_label.name = peer_id + "_points"
	points_label.size_flags_horizontal = SIZE_SHRINK_END
	points_label.add_font_override("font", players_font)
	points_label.text = "0"
	player["points"] = points_label
	
	players_node.add_child(nickname_label) 
	players_node.add_child(player_color)
	players_node.add_child(points_label)
	
	players[peer_id] = player


func add_guest(peer_id):
	add_player(peer_id, default_name, default_color)


func remove_player(peer_id):
	for node_name in players[peer_id]:
		players[peer_id][node_name].queue_free()
	players.erase(peer_id)

