class_name Launch extends Node

var parsed: Dictionary = {}
var is_server: bool
var player_name: String = ""

func _ready():
	parse_command_line_args()

func parse_command_line_args():
	var parser = CommandLineParser.new()
	parser.add_option("server", "s", TYPE_BOOL, false)
	parser.add_option("player_name", "p", TYPE_STRING, "")
	parsed = parser.parse()
	
	is_server = parsed.get("server")
	player_name = parsed.get("player_name")
	
	if not player_name.is_empty():
		get_window().title = get_window().title + " " + player_name
		
	if is_server:
		server.start()
		get_window().title = get_window().title + " --sever"
