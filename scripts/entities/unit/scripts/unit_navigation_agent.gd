class_name UnitNavigationAgent extends NavigationAgent2D

func _ready() -> void:
	var unit: Unit = self.get_parent()
	if unit is Unit:
		unit.navigation_agent = self
		unit.got_move_target.connect(set_target_position)
