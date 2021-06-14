extends Node2D

var positions = [Vector2(50, 300), Vector2(1870, 300)]
var rotations = [0, 180]

var goal_margin = 100 # should be set to approx. distance of goal collider from paddle

# players amount
func prepare(players):
	var center = get_viewport_rect().size / 2
	rotations = []
	positions = []
	var base_vector = Vector2(-center.y+goal_margin, 0)
	var vectors = [base_vector]
	if players == 3:
		base_vector = Vector2(-center.y*2/3+goal_margin, 0)
	
	for rot in range(0, 360, 360/players):
		rotations.append(rot)
		if rot != 0:
			vectors.append(base_vector.rotated(deg2rad(rot)))
	for vector in vectors:
		positions.append(center+vector)


func set_players_positions():
	var all_players = Singleton.get_networking().players + [str(get_tree().get_network_unique_id())]
	prepare(len(all_players))
	all_players.sort()
	for node in get_children():
		if node is Player:
			var id = all_players.find(node.name)
			node.position = positions[id]
			node.rotate(deg2rad(rotations[id]))
