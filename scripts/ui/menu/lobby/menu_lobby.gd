class_name MenuLobby extends CanvasLayer

@onready var text_connection_log: TextEdit = $ConnectionLog
@onready var textedit_chat: LineEdit = $ChatInput
@onready var button_return: Button = $Return

func _ready():
	textedit_chat.text_submitted.connect(_on_chat_message_submitted)
	button_return.pressed.connect(_on_button_return_pressed)

func _got_system_message(message: String, _error: bool):
	text_connection_log.text += message + "\n"
	
func _on_chat_message_submitted(message: String):
	client.send_chat_message(message)
	
func _on_chat_message_recived(sender_id: int, message: String):
	pass
	#var name = player_manager.players[sender_id].name
	#text_connection_log.text += name + ": " + message + "\n"
	
func _on_button_return_pressed():
	pass
