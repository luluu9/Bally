extends Control

signal connect(ip, port)

onready var ip_node = $VBoxContainer/IpEdit
onready var port_node = $VBoxContainer/PortEdit
onready var response_node = $VBoxContainer/ResponseLabel

func _on_ConnectButton_pressed():
	var ip = ip_node.text
	var port = int(port_node.text)
	if not ip:
		response_node.text = "IP address not given!"
		return
	if not port:
		response_node.text = "Port not given!"
		return
	emit_signal("connect", ip, port)
	
