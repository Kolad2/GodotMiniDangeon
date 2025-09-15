class_name HitBox extends Area2D

signal got_damage(value: float, source: Variant)


func _ready():
	var unit: Unit = self.get_parent()
	if unit is Unit:
		unit.hitbox = self


func hit(value: float, source: Variant):
	got_damage.emit(value, source)
	print("hit")
