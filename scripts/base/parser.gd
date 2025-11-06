class_name CommandLineParser extends RefCounted

signal parsed(options: Dictionary)
signal error(message: String)

var _options: Dictionary = {}
var _shorts_to_long: Dictionary = {}
var _parsed: Dictionary = {}

func add_option(
	name: String,
	short: String = "",
	opt_type: int = TYPE_STRING,
	default_value = null,
	help_text: String = ""
) -> CommandLineParser:
	var opt_name: String = name.to_snake_case().to_lower()
	var action: String = "store_true" if opt_type == TYPE_BOOL else "store"
	_options[opt_name] = {
		"type": opt_type,
		"default": default_value,
		"short": short.to_lower() if short else "",
		"help": help_text,
		"action": action
	}
	if short:
		_shorts_to_long[short.to_lower()] = opt_name
	return self

func parse(user_args: PackedStringArray = []) -> Dictionary:
	if user_args.is_empty():
		user_args = OS.get_cmdline_args()
	
	_parsed.clear()
	for opt_name in _options:
		_parsed[opt_name] = _options[opt_name]["default"]
	
	var i: int = 0
	while i < user_args.size():
		var arg: String = user_args[i]
		var opt_name: String = ""
		var value_str: String = ""
		
		if arg.begins_with("--"):
			var eq_pos: int = arg.find("=")
			if eq_pos != -1:
				opt_name = arg.substr(2, eq_pos - 2).to_lower()
				value_str = arg.substr(eq_pos + 1)
			else:
				opt_name = arg.substr(2).to_lower()
		elif arg.begins_with("-") and arg.length() > 1:
			opt_name = arg.substr(1).to_lower()
		
		# **КРИТИЧЕСКИЙ ФИКС: маппинг short**
		if opt_name.length() == 1 and _shorts_to_long.has(opt_name):
			opt_name = _shorts_to_long[opt_name]
		
		if opt_name in _options:
			var opt_info: Dictionary = _options[opt_name]
			if opt_info["action"] == "store_true":
				_parsed[opt_name] = true
			else:
				if value_str.is_empty():
					i += 1
					if i < user_args.size():
						value_str = user_args[i]
					else:
						error.emit("Missing value for %s" % opt_name)
						break
				_set_value(opt_name, value_str, opt_info)
			i += 1
			continue
		
		i += 1
	
	parsed.emit(_parsed)
	return _parsed

func print_help() -> void:
	print("Использование: [программа] [опции]")
	print("Доступные опции:")
	var sorted_keys = _options.keys()
	sorted_keys.sort()
	for opt_name in sorted_keys:
		var opt: Dictionary = _options[opt_name]
		var flags: Array[String] = []
		if opt["short"]:
			flags.append("-" + opt["short"])
		flags.append("--" + opt_name)
		print("  %s  %s" % [" / ".join(flags), opt["help"]])

func _set_value(opt_name: String, val_str: String, opt_info: Dictionary) -> void:
	match opt_info["type"]:
		TYPE_INT:
			if val_str.is_valid_int():
				_parsed[opt_name] = val_str.to_int()
			else:
				push_warning("Invalid int '%s' for %s" % [val_str, opt_name])
		TYPE_FLOAT:
			if val_str.is_valid_float():
				_parsed[opt_name] = val_str.to_float()
			else:
				push_warning("Invalid float '%s' for %s" % [val_str, opt_name])
		TYPE_BOOL:
			_parsed[opt_name] = val_str.to_lower() in ["true", "1", "yes", "on"]
		_:
			_parsed[opt_name] = val_str
