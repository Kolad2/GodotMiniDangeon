class_name ConnectionENetServer extends Node

const PORT = 7000

func _ready():
	server_start(PORT)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func server_start(port: int, max_peers: int = 32):
	var enet = ENetMultiplayerPeer.new()
	var result = enet.create_server(port, max_peers)
	if result != OK:
		push_error("Ошибка запуска сервера: %d" % result)
		return
	if result == OK:
		multiplayer.multiplayer_peer = enet
		print("сервер заапущен")

func _on_peer_connected(peer_id: int):
	print("peer ", peer_id," connected")

func _on_peer_disconnected(peer_id: int):
	print("peer ", peer_id," disconnected")
