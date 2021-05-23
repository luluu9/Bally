extends Control

func start():
	if get_tree().is_network_server():
		print("I am server")
		print("ID: " + str(get_tree().get_network_unique_id()))
	else:
		print("I am peer")
		print("ID: " + str(get_tree().get_network_unique_id()))
	
