class_name UnitSprite extends AnimatedSprite2D


func _ready() -> void:
	var unit: Unit = self.get_parent()
	if unit is Unit:
		unit.animated_sprite = self
		unit.ready.connect(_on_unit_ready)
	

func _on_unit_ready():
	var unit = self.get_parent()
	print("test")
	if unit.sprite_frames:
		print("test 2")
		self.sprite_frames = unit.sprite_frames
	
	
