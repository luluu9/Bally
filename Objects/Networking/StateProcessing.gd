extends Node

onready var networking = Singleton.get_networking_node()

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	# should we pass nodepath as key?
	# it could make everything synced easily
	# print(networking.current_state)
	for player in networking.current_state:
		if player == 1:
			continue
		get_node("/root/Game/World/"+str(player)+"/Paddle").position = networking.current_state[player]["position"]
	
