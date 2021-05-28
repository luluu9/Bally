extends Node

var positions = [Vector2(0, 300), Vector2(1000, 300)]

func _ready():
	pass

func add_child(node, unique_name=false):
	Singleton.get_networking_node().players.sort()
	var id = Singleton.get_networking_node().players.find(int(node.name))
	print(node.name, id)
	if id != -1:
		node.position = positions[id]
	.add_child(node, unique_name)
