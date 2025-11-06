class_name Server extends Node

var connection: ConnectionENetServer
var receiver: ServerReceiver
var session_manager: ServerSessionManager

func _enter_tree() -> void:
	connection = ConnectionENetServer.new()
	receiver = ServerReceiver.new()
	session_manager = ServerSessionManager.new()

func _ready() -> void:
	add_child(connection)
	add_child(receiver)
	add_child(session_manager)
	#
	receiver.request_host.connect(session_manager._new_session_request)

func start():
	connection.start()
