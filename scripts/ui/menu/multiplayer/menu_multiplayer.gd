class_name MultiplayerMenu extends CanvasLayer
# network: Network (Autoload)

@onready var button_host :Button = $HostGame
@onready var button_join :Button = $JoinGame
@onready var text_connection_log: TextEdit = $ConnectionLog
@onready var textedit_nickname: LineEdit = $Nickname

func _ready():
	button_host.pressed.connect(_on_host_button_pressed)
	button_join.pressed.connect(_on_join_button_pressed)
	
func _on_host_button_pressed():
	client.server_host_request()
	
func _on_join_button_pressed():
	client.server_join_request()
	
func _got_system_messege(messege: String, _error: bool):
	text_connection_log.text += messege + "\n"

#func _exit_tree():
	#if connection.status_changed.is_connected(_got_system_messege):
		#connection.status_changed.disconnect(_got_system_messege)
