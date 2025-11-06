class_name ConnectionENetClient extends Node

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1"

signal status_changed(message: String, is_error: bool)
var peer: MultiplayerPeer

func join_server(address: String = ""):
	var msg
	if multiplayer.multiplayer_peer is ENetMultiplayerPeer:
		msg = "Соединение уже существует"
		self.status_changed.emit(msg)
		return false
		
	if peer == null:
		service_init()
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	
	var error = peer.create_client(address, PORT)
	if error != OK:
		print("ошибка")
		return error
	multiplayer.multiplayer_peer = peer
	
	msg = "Попытка соединения c " + address + "."
	self.status_changed.emit(msg)
	
	
func is_active() -> bool:
	if multiplayer.multiplayer_peer == null:
		return false
	return peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED

func quit():
	var message
	if is_active():
		multiplayer.multiplayer_peer.close()
		message = "Отключение от сервера завершено"
		self.status_changed.emit(message)
	else:
		message = "Нет активного подключения для отключения"
	self.status_changed.emit(message)

func service_init():
	if peer != null:
		return false
	peer = ENetMultiplayerPeer.new()
	multiplayer.connected_to_server.connect(_on_connection_success)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	return true

func service_destroy():
	if peer == null:
		return false
	if is_active():
		quit()
	peer = null
	multiplayer.multiplayer_peer = null
	multiplayer.connected_to_server.disconnect(_on_connection_success)
	multiplayer.connection_failed.disconnect(_on_connection_failed)
	return true

func _on_server_disconnected():
	var message = "Соединение с сервером потеряно!"
	multiplayer.multiplayer_peer = null
	status_changed.emit(message)

func _on_connection_failed():
	var message = "Не удалось подключиться к серверу!"
	status_changed.emit(message)

func _on_connection_success():
	var message = "Успешное подключение к серверу!"
	status_changed.emit(message)

func _on_system_massage(msg: String):
	var client_id: int
	if multiplayer.multiplayer_peer != null:
		client_id =  multiplayer.get_unique_id()
	else:
		client_id = 0
	print("Client ", client_id, ": ", msg)

func _ready() -> void:
	status_changed.connect(_on_system_massage)

func _exit_tree() -> void:
	service_destroy()
