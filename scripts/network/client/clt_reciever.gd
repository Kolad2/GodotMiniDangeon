class_name ClientReciever extends Node

signal response_hosted(msg: Variant)
signal response_joined(msg: Variant)

func _ready():
	communicator.client_recived.connect(_got_server_message)
	event_bus.connect_signal("connected_to_lobby", response_hosted)
	event_bus.connect_signal("connected_to_lobby", response_joined, )

func _got_server_message(type: int, msg: Variant):
	match type:
		ServerMSG.HOSTED:
			response_hosted.emit(msg)
			print("Client: got hosted event: ", msg)
			return
		ServerMSG.JOINED:
			response_joined.emit(msg)
			print("Client: got join enent: ", msg)
			return
		ServerMSG.CHAT_MESSAGE:
			var sender_id = msg["sender"]
			var text = msg["text"]
			print("Client: ", text)
			return
	print("Client: got message, type: ", type, ", msg: ", msg)
