class_name Client extends Node

var connection: ConnectionENetClient
var session: ClientSession
var reciever: ClientReciever

func _enter_tree() -> void:
	connection = ConnectionENetClient.new()
	session = ClientSession.new()
	reciever = ClientReciever.new()

func _ready() -> void:
	add_child(connection)
	add_child(session)
	add_child(reciever)
	
func server_host_request() -> void:
	connection.join_server()
	session.host_request()

func server_join_request() -> void:
	connection.join_server()

func send_chat_message(msg: String):
	communicator.send_to_server(ClientMSG.CHAT_MESSAGE, msg)
