class_name Set extends RefCounted

var _elements := {}  # Основное хранилище (ключи = элементы, значения = true)

# Добавляет элемент (возвращает true, если элемент был добавлен, false если уже был)
func add(element) -> bool:
	if not _elements.has(element):
		_elements[element] = true
		return true
	return false

# Удаляет элемент (возвращает true, если элемент был удалён)
func erase(element) -> bool:
	return _elements.erase(element)

# Проверяет наличие элемента (аналог 'in')
func has(element) -> bool:
	return _elements.has(element)

# Возвращает размер множества
func size() -> int:
	return _elements.size()

# Очищает множество
func clear() -> void:
	_elements.clear()

# Возвращает массив элементов (для итерации)
func to_array() -> Array:
	return _elements.keys()

# --- Методы итератора ---

# Инициализация итератора
func _iter_init(arg) -> bool:
	var keys: Array = _elements.keys()
	if keys.is_empty():
		return false
	arg[0] = [0, keys]
	return true

# Переход к следующему элементу
func _iter_next(arg) -> bool:
	arg[0][0] += 1
	return arg[0][0] < arg[0][1].size()

# Получение текущего элемента
func _iter_get(state):
	return state[1][state[0]]
