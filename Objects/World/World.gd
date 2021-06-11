extends Node2D

var positions = [Vector2(50, 300), Vector2(1870, 300)]
var rotations = [0, 180]

var prepared = false


# players amount
func prepare(players):
	var center = get_viewport_rect().size / 2
	var world_size = center.y * 2
	rotations = []
	positions = []
	var base_vector = Vector2(-center.y * 2 / players, 0)
	var vectors = [base_vector]
	for rot in range(0, 360, 360/players):
		rotations.append(rot)
		if rot != 0:
			vectors.append(base_vector.rotated(deg2rad(rot)))
	for vector in vectors:
		positions.append(center+vector)
	prepared = true
	print(positions, rotations)


func add_child(node, all_players=[], unique_name=false):
	if not prepared:
		if all_players:
			prepare(len(all_players))
		else:
			prepare(len(Singleton.get_networking().players) + 1)
	if node is Player:
		if not all_players:
			all_players = Singleton.get_networking().players + [get_tree().get_network_unique_id()]
		all_players.sort()
		var id = all_players.find(int(node.name))
		node.position = positions[id]
		node.rotate(deg2rad(rotations[id]))
		print(node.position, id)
	.add_child(node, unique_name)
