class_name Unit extends CharacterBody2D

@export var health: float = 100.
@export var max_health: float = 100. 
@export var z_layer: int = 0
@export var speed = 100
@export var sprite_frames: SpriteFrames
@export_group("Navigation")
@export var target_position: Vector2:
	set(value):
		target_position = value
		got_move_target.emit(target_position)
@export var navigation_enabled: bool = true

signal got_move_target(target: Vector2)
# Children Nodes
var facing: Direction = Direction.DOWN
var animation_player: UnitAnimationPlayer
var animated_sprite: AnimatedSprite2D
var navigation_agent: UnitNavigationAgent
var damage_agent: DamageAgent
var hitbox: HitBox
#
var order_queue = Queue.new(2)
var action_timer: Timer
var busy: bool = false


func issue_order(order: String):
	if order == "attack":
		return self.order_queue.push_back("attack")
	return false


func _execute_action(action: String):
	if action == "attack":
		busy = true
		self.action_timer.start(0.8)
		self.attack()


func attack():
	self.damage_agent.hit()
	self.animation_player.play_melee_attack(facing)


func _ready() -> void:
	if navigation_agent and navigation_enabled:
		navigation_agent.target_position = target_position
	if damage_agent and hitbox:
		damage_agent.add_exeption(hitbox)
	if not action_timer:
		action_timer = Timer.new()
		self.add_child(action_timer)
		self.action_timer.timeout.connect(_on_action_end)
		self.action_timer.one_shot = true


func _on_action_end():
	self.busy = false


func _physics_process(_delta: float) -> void:
	if busy:
		return
	var action = order_queue.pop_front()
	if action == "attack":
		self._execute_action("attack")
		return
	
	var move_vec = self._get_move_vec()
	var direction = Direction.from_vector_x4(move_vec)
	if direction == Direction.NULL:
		if animation_player:
			animation_player.play_idle(self.facing)
		return
	self.velocity = speed*move_vec
	self.facing = direction
	animation_player.play_walk(self.facing)
	move_and_slide()


func _get_move_vec():
	if not self.navigation_agent.is_navigation_finished():
		var path_point = self.navigation_agent.get_next_path_position()
		var vec_direction: Vector2 = self.to_local(path_point).normalized()
		return vec_direction
	else:
		return Vector2.ZERO
