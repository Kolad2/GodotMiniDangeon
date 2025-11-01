class_name MenuLobby extends CanvasLayer
# network: Network (Autoload)

@onready var text_connection_log: TextEdit = $ConnectionLog
@onready var textedit_chat: LineEdit = $ChatInput
@onready var button_return: Button = $Return

func _ready():
	connection.status_changed.connect(_got_system_message)
	textedit_chat.text_submitted.connect(_on_chat_message_submitted)
	network.got_message.connect(_on_chat_message_recived)
	button_return.pressed.connect(_on_button_return_pressed)

func _got_system_message(message: String, _error: bool):
	text_connection_log.text += message + "\n"
	
func _on_chat_message_submitted(message: String):
	self.textedit_chat.text = ""
	network.send_messege(message)

func _on_chat_message_recived(sender_id: int, message: String):
	var name = player_manager.players[sender_id].name
	text_connection_log.text += name + ": " + message + "\n"

func _on_button_return_pressed():
	connection.quit()
	self._change_to_multiplayer()

func _change_to_multiplayer():
	var loaded_menu = load("uid://dp8kbum8ec4jm")
	if not loaded_menu:
		push_error("Сцена не найдена!")
		return
	loaded_menu = loaded_menu.instantiate()
	var parent = get_parent()
	parent.add_child(loaded_menu)
	loaded_menu.text_connection_log.text = self.text_connection_log.text
	self.queue_free()
