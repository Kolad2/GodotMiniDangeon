class_name EventBus extends Node

var _sources: Dictionary   = {}
var _callables: Dictionary = {}


func connect_callable(event_name: String, callable: Callable):
	_add_subscriber(event_name, callable)
	_connect_sources(event_name, callable)

func disconnect_subscriber(event_name: String, callable: Callable):
	pass

func connect_signal(event_name: String, source: Signal):
	_add_source(event_name, source)
	_connect_callables(source, event_name)

func disconnect_signal(event_name: String):
	pass

func has_subscribers(event_name: String) -> bool:
	return _callables.has(event_name)

func has_sources(event_name: String) -> bool:
	return _sources.has(event_name)

## ------ Приватные методы ------ ##

func _add_source(event_name: String, source: Signal):
	if not has_sources(event_name):
		_sources[event_name] = Set.new()
	if not _sources[event_name].has(source):
		_sources[event_name].add(source)

func _add_subscriber(event_name: String, callable: Callable):
	if not has_subscribers(event_name):
		_callables[event_name] = Set.new()
	if not _callables[event_name].has(callable):
		_callables[event_name].add(callable)

func _connect_sources(event_name: String, callable: Callable):
	if has_sources(event_name):
		for source in _sources[event_name]:
			source.connect(callable)

func _connect_callables(source: Signal, event_name: String):
	if has_subscribers(event_name):
		for callable in _callables[event_name]:
			source.connect(callable)
