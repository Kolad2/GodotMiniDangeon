# class_name PlayerManager extends Node
# connection (Autoload) instance of Connection

#var my_player = {}
#var players = {}
#
#func _ready():
	#pass
	##if connection:
		##multiplayer.peer_connected.connect(_on_peer_connected)
		##multiplayer.connected_to_server.connect(_on_connection_success)
		##connection.hosted.connect(_on_connection_success)
#
#func setup(name: String):
	#my_player["name"] = name
#
#func _on_connection_success():
	#players[multiplayer.get_unique_id()] = my_player
#
#func _on_peer_connected(peer_id: int):
	#send_data_to_peer(peer_id, my_player)
#
#func send_data_to_peer(peer_id: int, data):
	#rpc_id(peer_id, "_on_data_received", multiplayer.get_unique_id(), data)
#
#@rpc("any_peer", "reliable")
#func _on_data_received(sender_id: int, data: Dictionary):
	#players[sender_id] = data
