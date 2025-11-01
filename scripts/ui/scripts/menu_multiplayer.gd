class_name MultiplayerMenu extends CanvasLayer
# network: Network (Autoload)

@onready var button_host :Button = $HostGame
@onready var button_join :Button = $JoinGame
@onready var text_connection_log: TextEdit = $ConnectionLog
@onready var textedit_nickname: LineEdit = $Nickname

func _ready():
	button_host.pressed.connect(_on_host_button_pressed)
	button_join.pressed.connect(_on_join_button_pressed)
	connection.status_changed.connect(_got_system_messege)
	
func _on_host_button_pressed():
	connection.host()
	self._change_to_lobby()
	
func _on_join_button_pressed():
	#connection.join(adress)
	if not multiplayer.connected_to_server.is_connected(_on_lobby_connected):
		multiplayer.connected_to_server.connect(_on_lobby_connected)

func _on_lobby_connected():
	self._change_to_lobby()

func _got_system_messege(messege: String, _error: bool):
	text_connection_log.text += messege + "\n"

func _change_to_lobby():
	var lobby_scene = load("uid://bnx5uj3ukcxxk")
	if not lobby_scene:
		push_error("Сцена лобби не найдена!")
		return
	var lobby_instance = lobby_scene.instantiate()
	var parent = get_parent()
	parent.add_child(lobby_instance)
	lobby_instance.text_connection_log.text = self.text_connection_log.text
	self.queue_free()
	
func _exit_tree():
	if connection.status_changed.is_connected(_got_system_messege):
		connection.status_changed.disconnect(_got_system_messege)
