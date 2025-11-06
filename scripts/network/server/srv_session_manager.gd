class_name ServerSessionManager extends Node

signal session_created()
var sessions = []

func new_session():
	print("Server: Созданна сессия")
	var session = ServerSession.new()
	add_child(session)
	sessions.append(session)
	session_created.emit()
	
func _new_session_request(sender_id: int, _msg: Variant):
	print("Server: got host request")
	if sessions.size() < 1:
		new_session()
		communicator.send_to_client(sender_id, ServerMSG.HOSTED, "Заходим не тупим")
	else:
		print("Server: host request rejected from ", sender_id)
		multiplayer.multiplayer_peer.get_peer(sender_id).peer_disconnect_now()
