class_name RemouteCommunicator extends Node


signal server_recived(sender_id: int ,type: int, msg: Variant)
signal client_recived(type: int, msg: Variant)

func send_to_server(type: int, msg: Variant = ""):
	rpc_id(1, "_server_received", multiplayer.get_unique_id(), type, msg)

func send_to_client(receiver_id: int, type: int, msg: Variant = ""):
	rpc_id(receiver_id, "_client_received", type, msg)

@rpc("authority", "reliable")
func _client_received(type: int, msg: Variant):
	client_recived.emit(type, msg)

@rpc("any_peer", "reliable")
func _server_received(sender_id: int, type: int, msg: Variant):
	server_recived.emit(sender_id, type, msg)
