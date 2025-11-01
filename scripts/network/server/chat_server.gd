class_name NetworkServer extends Node

@rpc("any_peer", "reliable")
func _message_received(sender_id: int, message: String):
	print("Полученно сообщение: ", message)
	rpc("_message_received", sender_id, message)
