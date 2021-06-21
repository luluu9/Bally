extends Node

onready var game_node = get_node("/root/Game")
onready var networking = get_node("/root/Game/Networking")
onready var score_node = get_node("/root/Game/UILayer/Screens/GameScreen/HBoxContainer/Score")
onready var lobby_screen = get_node("/root/Game/UILayer/Screens/LobbyScreen")
onready var game_screen = get_node("/root/Game/UILayer/Screens/GameScreen")

func get_game_node():
	return game_node


func get_networking():
	return networking


func get_score_node():
	return score_node


func get_lobby_screen():
	return lobby_screen


func get_game_screen():
	return game_screen
