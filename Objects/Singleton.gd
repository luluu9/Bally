extends Node

onready var game_node = get_node("/root/Game")
onready var networking_node = get_node("/root/Game/Networking")

func get_game_node():
	return game_node


func get_networking_node():
	return networking_node
