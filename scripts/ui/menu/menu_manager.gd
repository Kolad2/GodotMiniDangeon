class_name MenuManager extends Node

const UID_LOBBY = "uid://bnx5uj3ukcxxk"
const UID_MULTIPLAYER = "uid://dp8kbum8ec4jm"

var _menu_paths: Dictionary = {
	"lobby": UID_LOBBY,
	"multiplayer": UID_MULTIPLAYER
}
var _menu: Dictionary = {}

func _ready():
	lobby_scene_init()
	multiplayer_scene_init()
	_menu["multiplayer"].show()

func lobby_scene_init():
	_menu["lobby"] = _add_menu_scene(_menu_paths["lobby"])
	event_bus.connect_callable("connected_to_lobby", _on_lobby_connected)

func multiplayer_scene_init():
	_menu["multiplayer"] = _add_menu_scene(UID_MULTIPLAYER)

func _on_lobby_connected(msg):
	_menu["lobby"].show()
	_menu["multiplayer"].hide()

func _add_menu_scene(scene_path: String):
	var packed_scene: PackedScene = load(scene_path)
	if not packed_scene:
		push_error("Сцена не найдена!")
		return
	var scene: Node = packed_scene.instantiate()
	add_child(scene)
	scene.hide()
	return scene
