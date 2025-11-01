class_name Launch extends Node

var player_name: String = "DefaultPlayer"
var is_debug: bool = false

func _ready():
	parse_command_line_args()

func parse_command_line_args():
	var args = OS.get_cmdline_args()
	var i = 0
	while i < args.size():
		match args[i]:
			"--player_name":
				if i + 1 < args.size():
					player_name = args[i + 1]
					i += 2
				else:
					i += 1
			"--debug":
				is_debug = true
				i += 1
			_:
				i += 1
