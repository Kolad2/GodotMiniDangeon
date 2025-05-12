class_name Queue extends RefCounted # Deque
 
var _data: Array[Variant]
var _capacity: int
var _front: int = 0
var _rear: int = 0
var _size: int = 0

# Конструктор: создаёт deque с заданной ёмкостью
func _init(capacity: int) -> void:
	assert(capacity > 0, "Capacity must be positive")
	self._capacity = capacity
	_data = []
	_data.resize(capacity)


# --- Добавление элементов ---
# В конец очереди
func push_back(value) -> bool:
	if is_full():
		return false
	_data[_rear] = value
	_rear = (_rear + 1) % _capacity
	_size += 1
	return true

# В начало очереди
func push_front(value) -> bool:
	if is_full():
		return false
	_front = (_front - 1 + _capacity) % _capacity
	_data[_front] = value
	_size += 1
	return true

# Удаляет и возвращает элемент с конца
func pop_back():
	if is_empty():
		return null
	_rear = (_rear - 1 + _capacity) % _capacity
	_size -= 1
	return _data[_rear]

# Удаляет и возвращает элемент с начала
func pop_front() -> Variant:
	if is_empty():
		return null
	var value = _data[_front]
	_front = (_front + 1) % _capacity
	_size -= 1
	return value

# Возвращает элемент с начала без удаления
func peek_front():
	return null if is_empty() else _data[_front]

# Возвращает элемент с конца без удаления
func peek_back():
	return null if is_empty() else _data[(_rear - 1 + _capacity) % _capacity]

# Проверяет, пуста ли очередь
func is_empty() -> bool:
	return _size == 0

# Проверяет, заполнена ли очередь
func is_full() -> bool:
	return _size == _capacity

# Возвращает текущее количество элементов
func get_size() -> int:
	return _size

# Возвращает максимальную ёмкость
func get_capacity() -> int:
	return _capacity

# Очищает очередь
func clear() -> void:
	_front = 0
	_rear = 0
	_size = 0
	_data.clear()
