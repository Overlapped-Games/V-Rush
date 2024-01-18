class_name Danmaku extends Node2D


signal execute


enum PatternType {
	ONE_SHOT,
	REPEATABLE
}


enum Angle {
	FIXED,	# aim towards given direction; relative to this pattern's position
	CHASE	# aim towards target
}


#@onready var pool : Node2D = $Pool

@export var bullet_type : BulletUtil.BulletType
@export var bullet_shape := BulletUtil.BulletShape.CIRCLE
@export var shape_properties := {}

var move_f : Callable:
	set(value):
		move_f = value
		moving = true
var sequence : Callable
var target : Vector2
#var pattern_origin : Vector2
#var bullet_scn : PackedScene

var angle_type : Angle = Angle.FIXED
var fire_angle_modifier := 0.0
var pattern_rot := 0.0
var stacks := 1
var velocity_modifier := 0.0
var t_m := 0.0

## If 0, repeats until told to stop
var max_repeats := 0
var repeats := 0
var repeatable : Callable
var call_rate := 1.0
var call_delay := 0.0
var repeats_to_delay := 1
var t := 0.0
var spin_rate := 0.0
var max_bounces := 0

var active := false
var repeating := false
var delaying_call := false
var stacking := false
var moving := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if !pool:
		#pool = Node2D.new()
		#pool.name = "Pool"
		#add_child(pool)
	#if !timers:
		#timers = Node.new()
		#timers.name = "Timers"
		#add_child(timers)
	move_f = func(delta): pass
	set_physics_process(false)


func _physics_process(delta : float) -> void:
	_try_move(delta)
	_pattern_process(delta)
	#print("%s:%s" % [name, bullet_count])


# TODO: match up movement with bullet spawns. be able to form patterns more consistently
func _try_move(delta : float) -> void:
	if move_f.is_valid():
		move_f.call(delta)


#
func circle_move(delta : float, speed := 4, radius := 1.0, rotations := 1) -> void:
	t_m += delta
	var angle = speed * t_m / (2 * PI)
	var rotation = Vector2(cos(angle), sin(angle))
	global_position = (rotation * radius).round()


# TODO: implement
func move_to(delta : float, speed : int, to_position : Vector2) -> void:
	pass


# TODO: implement
func move_in_direction(delta : float, speed : int, direction : Vector2) -> void:
	pass


func _pattern_process(delta : float) -> void:
	# stop repeating if reached repeat limit or not a repeating pattern
	if !repeating: return
	if max_repeats > 0 and repeats == max_repeats:
		#print(pool.get_child_count())
		_stop()
		return
	# calculate time until can call repeatable
	if delaying_call:
		t += call_delay * delta
		if t >= 1:
			delaying_call = false
			t = 0
		return
	t += call_rate * delta
	#print("PP, ", t)
	if t >= 1:
		#print("sec")
		t = 0
		repeatable.call()
		repeats += 1
		if spin_rate > 0:
			pattern_rot = pattern_rot + spin_rate if pattern_rot + spin_rate < 2 * PI else pattern_rot + spin_rate - (2 * PI)
		elif spin_rate < 0:
			pattern_rot = pattern_rot + spin_rate if pattern_rot + spin_rate > 0 else (2 * PI) + (pattern_rot + spin_rate)
		
		if repeats == repeats_to_delay and call_delay > 0:
			delaying_call = true
			repeats = 0


func _start():
	active = true
	stacking = false
	stacks = 1
	velocity_modifier = 0.0
	delaying_call = false
	repeating = false
	repeatable = func(): pass
	repeats = 0
	max_repeats = 0
	call_rate = 1.0
	t = 0
	t_m = 0
	pattern_rot = 0.0
	spin_rate = 0
	max_bounces = 0
	fire_angle_modifier = 0
	sequence.call()
	set_physics_process(true)


func _stop() -> void:
	active = false
	stacking = false
	stacks = 1
	velocity_modifier = 0.0
	delaying_call = false
	repeating = false
	repeatable = func(): pass
	repeats = 0
	max_repeats = 0
	call_rate = 1.0
	t = 0
	t_m = 0
	pattern_rot = 0.0
	spin_rate = 0
	max_bounces = 0
	fire_angle_modifier = 0
	set_physics_process(false)


func _kill() -> void:
	_stop()
	#for child in pool.get_children():
		#child.queue_free()


func fixed(target_pos : Vector2, bullet_t : BulletUtil.BulletType,  f : Callable) -> void:
	angle_type = Angle.FIXED
	target = global_position + target_pos
	bullet_type = bullet_t
	sequence = f


func chase(bullet_t : BulletUtil.BulletType,  f : Callable) -> void:
	angle_type = Angle.CHASE
	bullet_type = bullet_t
	sequence = f


func update_target() -> void:
	if angle_type == Angle.CHASE:
		target = get_tree().get_first_node_in_group("player").global_position
		
		
func delay(delay := 0.0, repeats_delay := 1, f : Callable = func(): pass) -> void:
	call_delay = delay
	repeats_to_delay = repeats_delay
	f.call()


# repeat following pattern at rate
func repeat(rate := 1.0, max := 0, f : Callable = func(): pass) -> void:
	repeating = true
	repeatable = f
	repeats = 0
	max_repeats = max
	call_rate = rate
	t = 0


# actually fire particle
func fire(f : Callable) -> void:
	#while pool.get_child_count() < MAX_BULLETS:
		#pool.add_child(bullet_scn.instantiate())
	update_target()
	f.call()


func laser(f : Callable = func(): pass) -> void:
	pass


func wave() -> void:
	pass


func curve() -> void:
	pass


func lines(lines := 1, fire_angle := 0.0, spread := 1, spread_degrees := 0.0, origin_offset := 1, velocity := 100, acceleration := 0, max_velocity := 500, f : Callable = func(bullet : Bullet = null): pass) -> void:
	if spread < 1: spread = 1
	var pattern_origin := global_position
	var origin := Vector2(pattern_origin.x + (origin_offset * cos(360.0/lines)), pattern_origin.y + (origin_offset * sin(360.0/lines)))
	#print("%s vs %s" % [pattern_origin, origin])
	# get spread angle
	var spread_rad : float = spread_degrees * PI / 180
	var dir_to_target : Vector2 = pattern_origin.direction_to(target)
	# odd aims at target, even aims at the sides
	#var direction = dir_to_target.from_angle(dir_to_target.angle() + fire_angle) if spread % 2 != 0 else dir_to_target.from_angle(dir_to_target.angle() + fire_angle + (spread_rad / 2))
	var direction = dir_to_target if spread % 2 != 0 else dir_to_target.from_angle(dir_to_target.angle() + fire_angle + (spread_rad / 2))
	var radians : float = 2 * PI / lines # convert to radians for function params
	f.call()
	# stacks
	for stack in range(1, stacks + 1):
		var v = velocity + (velocity * velocity_modifier * stack)
		# fire additional lines if should spread from a given line
		#print("%s - %s = %s" % [ceil(spread / 2.0), ceil(-spread / 2.0), ceil(spread / 2.0) - ceil(-spread / 2.0)])
		for i in range(ceil(-spread / 2.0), ceil(spread / 2.0)):
			var fire_direction : Vector2
			var angle : float
			var fire_origin : Vector2
			var bullet : Bullet
			#print("i=%s, %s, %s, %s" % [i, 1 + (i * spread_rad), direction, dir])
			for line in range(1, lines + 1):
				bullet = BulletUtil.get_next_bullet(bullet_type)
				#print("firing[%s] - %s" % [line, dir.from_angle(dir.angle() + pattern_rot + (radians * line))])
				angle = (direction.angle() + pattern_rot + radians) + (radians * line)
				fire_origin = pattern_origin + (origin.from_angle(angle) * origin_offset)
				fire_direction = pattern_origin.from_angle(angle + (i * spread_rad) + ((fire_angle + fire_angle_modifier) * PI / 180))
				#print("%s, %s,%s" % [pattern_origin, origin, pattern_origin + origin.from_angle(angle) * origin_offset])
				if max_bounces > 0: bullet.max_bounces = max_bounces
				bullet._fire(fire_origin, fire_direction, bullet_shape, v, acceleration, max_velocity, shape_properties)
				
				## FOR DEBUGGING PURPOSES ##
				#if stack == 1 and i == ceil(-spread / 2.0) and line == 1:
					#bullet.self_modulate = Color.BLACK
				#else:
					#bullet.self_modulate = Color.WHITE
					
				#bullet._fire()
				#bullet_count += 1
				#bullet.expired.connect(func(bullet : Bullet): bullet_count -= 1)


# convenience call for line + stack
#func fan_out(lines := 1, spread := 1, spread_degrees := 0.0, origin_offset := 0.0, count := 1, v_mod := 0.0, velocity := 100, acceleration := 0, max_velocity := 500, f : Callable = func(bullet : Bullet = null): pass) -> void:
	#lines(lines, spread, spread_degrees, origin_offset, velocity, acceleration, max_velocity, stack.bind(count, v_mod, f))


func spin(rate := 0.125, f : Callable = func(): pass) -> void:
	spin_rate = rate
	f.call()


func stack(count := 1, v_mod := 0.0, f : Callable = func(bullet : Bullet = null): pass) -> void:
	stacking = true
	stacks = count
	velocity_modifier = v_mod
	f.call()


# degrees
func random_angle(min := 0, max := 0, f : Callable = func(): pass) -> void:
	fire_angle_modifier = randf_range(min, max)
	f.call()


func bounce(max_bounces := 1, f : Callable = func(): pass) -> void:
	self.max_bounces = max_bounces
	f.call()
