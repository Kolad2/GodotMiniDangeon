class_name UnitAnimationPlayer extends AnimationPlayer

var walk_animation = {
	Direction.TOP: "walk_top", Direction.TOP_RIGHT: "walk_top_right",
	Direction.RIGHT: "walk_right", Direction.DOWN_RIGHT: "walk_down_right",
	Direction.DOWN: "walk_down", Direction.DOWN_LEFT: "walk_down_left",
	Direction.LEFT: "walk_left",  Direction.TOP_LEFT: "walk_top_left",
	}

var idle_animation = {
	Direction.TOP: "idle_top", Direction.TOP_RIGHT: "idle_top_right",
	Direction.RIGHT: "idle_right", Direction.DOWN_RIGHT: "idle_down_right",
	Direction.DOWN: "idle_down", Direction.DOWN_LEFT: "idle_down_left",
	Direction.LEFT: "idle_left",  Direction.TOP_LEFT: "idle_top_left",
}

var attack_animation = {
	Direction.TOP: "attack_top", Direction.TOP_RIGHT: "attack_top_right",
	Direction.RIGHT: "attack_right", Direction.DOWN_RIGHT: "attack_down_right",
	Direction.DOWN: "attack_down", Direction.DOWN_LEFT: "attack_down_left",
	Direction.LEFT: "attack_left",  Direction.TOP_LEFT: "attack_top_left",
}

func _ready() -> void:
	var unit: Unit = self.get_parent()
	if unit is Unit:
		unit.animation_player = self
		unit.ready.connect(_on_unit_ready)


func play_melee_attack(dir: Direction):
	play("animations/" + attack_animation[dir])


func play_walk(dir: Direction):
	play("animations/" + walk_animation[dir])


func play_idle(dir: Direction):
	play("animations/" + idle_animation[dir])


func flush_libraries():
	var library_names = self.get_animation_library_list()
	for lib_name in library_names:
		self.remove_animation_library(lib_name)


func _on_unit_ready():
	var unit: Unit = self.get_parent()
	self.flush_libraries()
	var animated_sprite = unit.get_node("AnimatedSprite2D")
	var lib = AnimationLibrary.new()
	for animation_name in animated_sprite.sprite_frames.get_animation_names():
		var anim = self.add_sprite_animation(animated_sprite, animation_name)
		lib.add_animation(animation_name, anim)
	self.add_animation_library("animations", lib)
	self.notify_property_list_changed()

func add_sprite_animation(sprite: AnimatedSprite2D, animation_name):
	var track_idx
	var dt = 0.1
	var frame_count = sprite.sprite_frames.get_frame_count(animation_name)
	var sprite_path = self.get_parent().get_path_to(sprite)
	#
	var anim = Animation.new()
	anim.length = dt*frame_count
	anim.set_loop_mode(Animation.LOOP_LINEAR)
	sprite.animation = animation_name
	track_idx = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_idx, NodePath(str(sprite_path) + ":animation"))
	anim.track_insert_key(track_idx, 0.0, animation_name)
	anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
	track_idx = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_idx, NodePath(str(sprite_path) + ":frame"))
	for i in range(frame_count):
		anim.track_insert_key(track_idx, dt*i, i)
	anim.value_track_set_update_mode(track_idx, Animation.UPDATE_DISCRETE)
	return anim
