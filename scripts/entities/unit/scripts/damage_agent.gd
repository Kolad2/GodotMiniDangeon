class_name DamageAgent extends Area2D

var source: Variant
var exeptions: Set = Set.new()


func add_exeption(area: Area2D):
	exeptions.add(area)

func hit():
	var areas: Array[Area2D] = self.get_overlapping_areas()
	if areas.size() == 0:
		return
	for area in areas:
		if area is HitBox and not exeptions.has(area):
			area.hit(0, self.source)

func _init() -> void:
	self.source = self


func _ready() -> void:
	var unit: Unit = self.get_parent()
	if unit is Unit:
		unit.damage_agent = self
		self.source = unit
		#unit.ready.connect(_on_unit_ready)
