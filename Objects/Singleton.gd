extends Node

onready var game_node = get_node("/root/Game")
onready var networking = get_node("/root/Game/Networking")
onready var score_node = get_node("/root/Game/UILayer/Screens/GameScreen/HBoxContainer/Score")

func get_game_node():
	return game_node


func get_networking():
	return networking


func get_score_node():
	return score_node
