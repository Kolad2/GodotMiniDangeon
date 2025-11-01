class_name NetworkClient extends Node

signal got_message(sender_id: int, messege: String)

func send_messege(message):
	rpc_id(1, "_message_received", multiplayer.get_unique_id(), message)
	
@rpc("reliable")
func _message_received(sender_id: int, message: String):
	got_message.emit(sender_id, message)
	
