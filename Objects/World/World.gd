extends Node2D

var positions = [Vector2(50, 300), Vector2(1870, 300)]
var rotations = [0, 180]


func _ready():
        pass


func add_child(node, unique_name=false):
		if node is Player:
			var all_players = Singleton.get_networking().players + [get_tree().get_network_unique_id()]
			all_players.sort()
			print(all_players)
			var id = all_players.find(int(node.name))
			node.position = positions[id]
			node.rotate(deg2rad(rotations[id]))
		.add_child(node, unique_name)
