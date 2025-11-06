class_name ClientSession extends Node

func host_request():
	multiplayer.connected_to_server.connect(_request_host)

func join_request():
	multiplayer.connected_to_server.connect(_request_join)

func _request_host():
	var msg = "Client: Отправка запроса на создание новой комнаты"
	print(msg)
	communicator.send_to_server(ClientMSG.HOST, "Сообщение")
	multiplayer.connected_to_server.disconnect(_request_host)
	
func _request_join():
	# логика отправки запроса на сервер о поключении к существующей свободной комнате
	multiplayer.connected_to_server.disconnect(_request_join)
