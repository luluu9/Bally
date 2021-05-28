extends Node

onready var game_node = get_node("/root/Game")
onready var networking = get_node("/root/Game/Networking")

func get_game_node():
	return game_node


func get_networking():
	return networking
