class_name ConnectionENetClient extends Node

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost

signal status_changed(message: String, is_error: bool)
signal synchronized()

func join(address: String = ""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var message = "Попытка соединения c " + address + "."
	self.status_changed.emit(message, false)
	var error = peer.create_client(address, PORT)
	if error != OK:
		print("ошибка")
		return error
	multiplayer.multiplayer_peer = peer

func quit():
	if multiplayer.has_multiplayer_peer():
		# Отключаемся от multiplayer peer
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		
		var message = "Отключение от сервера завершено"
		self.status_changed.emit(message, false)
	else:
		var message = "Нет активного подключения для отключения"
		self.status_changed.emit(message, true)


func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connection_success)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_connection_failed():
	var message = "Не удалось подключиться к серверу!"
	status_changed.emit(message, true)

func _on_connection_success():
	var message = "Успешное подключение к серверу!"
	status_changed.emit(message, false)

func _on_player_connected(peer_id: int):
	var message = "Plyaer " + str(peer_id) + " has joined"
	self.status_changed.emit(message, false)

func _on_player_disconnected(id: int):
	var my_id = multiplayer.get_unique_id()
	var message = "Я: " + str(my_id) + ", игрок " + str(id) + " отключился"
	self.status_changed.emit(message, false)
