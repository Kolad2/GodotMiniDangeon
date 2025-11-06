class_name ServerReceiver extends Node

signal request_host(sender_id: int, msg: Variant)
signal request_join(sender_id: int, msg: Variant)

func _ready():
	communicator.server_recived.connect(_got_client_message)

func _got_client_message(sender_id: int, type: int, msg: Variant):
	match type:
		ClientMSG.HOST:
			request_host.emit(sender_id, msg)
			return
		ClientMSG.JOIN:
			request_join.emit(sender_id, msg)
			print("Server: got join request")
			return
		ClientMSG.CHAT_MESSAGE:
			print("Server: сообщение от пользователя:\n", msg)
			communicator.send_to_client(sender_id, ServerMSG.CHAT_MESSAGE,
				{
					"sender": sender_id,
					"text": msg
				})
			return
	print("Server: got message, type: ", type, ", msg: ", msg)
