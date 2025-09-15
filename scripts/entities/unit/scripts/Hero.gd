class_name Hero extends Unit


func _get_move_vec():
	return GameInput.get_move_input()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			self.issue_order("attack")
