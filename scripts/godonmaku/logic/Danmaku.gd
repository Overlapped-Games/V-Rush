class_name Danmaku extends Node2D


signal execute


enum PatternType {
	RING,
	
}


enum Angle {
	FIXED,	# aim towards given direction; relative to this pattern's position
	CHASE	# aim towards target
}


#@onready var pool : Node2D = $Pool
@export_group("Pattern Settings")
@export var pattern_type : PatternType = PatternType.RING
@export var angle_type : Angle = Angle.FIXED
@export var pattern_origin := Vector2.ZERO
@export var fire_direction : Vector2

@export_group("Bullet settings")
@export var bullet_type : BulletUtil.BulletType
@export var move_type : Bullet.MoveType = Bullet.MoveType.LINE
@export_flags_2d_physics var hitbox_layer := 0b0010_0000_0000
@export var velocity : int = 100
@export var max_velocity : int = 1000
@export var acceleration : float = 0.0
@export var max_bounces : int = 0
@export var curve_angle : float = 0.0
@export var bullet_shape : BulletUtil.BulletShape = BulletUtil.BulletShape.CIRCLE
@export var shape_properties : Dictionary = {}

#var bullet_scn : PackedScene
var per_bullet_f : Callable = func(bullet : Bullet): pass
var move_f : Callable:
	set(value):
		move_f = value
		moving = true
var sequence : Callable


@export_group("Ring settings")
@export var line_count := 1
@export var fire_angle := 0.0
@export var spread := 1
@export var spread_degrees := 0.0
@export var origin_offset := 1
@export var fire_angle_modifier := 0.0
@export var pattern_rot := 0.0

@export_group("Stack settings")
@export var stacking : bool = false
@export var stacks : int = 1
@export var velocity_modifier : float = 0.0

@export_group("Spin settings")
@export var spin_rate : float = 0.0

# If 0, repeats until told to stop
@export_group("Repeat settings")
@export var repeating : bool = false
@export var max_repeats : int = 0
@export var repeats : int = 0
@export var repeatable : Callable
@export var processed_frames : float = 0.0
@export var repeat_frames : float = 0.0
@export var call_rate : float = 1.0
@export var call_delay : float = 0.0
@export var repeats_to_delay : int = 1

@export var moving : bool = false

var target : Vector2
var t_m : float = 0.0
var t : float = 0.0
var finished_processing : bool = false
var delaying_call : bool = false
var active : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	if finished_processing:
		return
		
	if !repeating and !finished_processing:
		#fired = true
		fire_pattern()
		finished_processing  = true
		return
		
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
	processed_frames += delta
	#print("PP, ", t)
	if t >= 1:
		#print("sec")
		t = 0
		#repeatable.call()
		fire_pattern()
		repeats += 1
		if spin_rate > 0:
			pattern_rot = pattern_rot + spin_rate if pattern_rot + spin_rate < 2 * PI else pattern_rot + spin_rate - (2 * PI)
		elif spin_rate < 0:
			pattern_rot = pattern_rot + spin_rate if pattern_rot + spin_rate > 0 else (2 * PI) + (pattern_rot + spin_rate)
		
		if repeats == repeats_to_delay and call_delay > 0:
			delaying_call = true
			repeats = 0
	
	if repeat_frames > 0 and processed_frames >= repeat_frames:
		_stop()


func fire_pattern() -> void:
	update_target()
	match pattern_type:
		PatternType.RING:
			fire_ring()


func update_target() -> void:
	if angle_type == Angle.CHASE:
		target = get_tree().get_first_node_in_group("player").global_position
	else:
		target = global_position + fire_direction


func _start() -> void:
	#active = true
	#stacking = false
	#stacks = 1
	#velocity_modifier = 0.0
	#delaying_call = false
	#repeating = false
	#repeatable = func(): pass
	#repeats = 0
	#max_repeats = 0
	#call_rate = 1.0
	#t = 0
	#t_m = 0
	#pattern_rot = 0.0
	#spin_rate = 0
	#max_bounces = 0
	#fire_angle_modifier = 0
	#move_type = Bullet.MoveType.LINE
	#per_bullet_f = func(bullet : Bullet): pass
	set_physics_process(true)
	
	#sequence.call()


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
	move_type = Bullet.MoveType.LINE
	per_bullet_f = func(bullet : Bullet): pass
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


func repeat_timed(rate := 1.0, frames := 60, f : Callable = func(): pass) -> void:
	repeating = true
	repeatable = f
	repeats = 0
	repeat_frames = frames
	call_rate = rate
	t = 0


# actually fire particle
func fire(f : Callable) -> void:
	update_target()
	f.call()


func laser(f : Callable = func(): pass) -> void:
	pass


func fire_ring() -> void:
	var pos = global_position
	pattern_origin = Vector2(pos.x + (origin_offset * cos(360.0/line_count)), pos.y + (origin_offset * sin(360.0/line_count)))
	#print("%s vs %s" % [pattern_origin, origin])
	# get spread angle
	var spread_rad : float = spread_degrees * PI / 180
	var dir_to_target : Vector2 = pos.direction_to(target)
	# odd aims at target, even aims at the sides
	#var direction = dir_to_target.from_angle(dir_to_target.angle() + fire_angle) if spread % 2 != 0 else dir_to_target.from_angle(dir_to_target.angle() + fire_angle + (spread_rad / 2))
	var direction = dir_to_target if spread % 2 != 0 else dir_to_target.from_angle(dir_to_target.angle() + fire_angle + (spread_rad / 2))
	var radians : float = 2 * PI / line_count # convert to radians for function params
	# stacks
	for stack in range(1, stacks + 1):
		var v = velocity + (velocity * velocity_modifier * stack)
		# fire additional ring if should spread from a given line
		#print("%s - %s = %s" % [ceil(spread / 2.0), ceil(-spread / 2.0), ceil(spread / 2.0) - ceil(-spread / 2.0)])
		for i in range(ceil(-spread / 2.0), ceil(spread / 2.0)):
			var fire_direction : Vector2
			var angle : float
			var fire_origin : Vector2
			var bullet : Bullet
			#print("i=%s, %s, %s, %s" % [i, 1 + (i * spread_rad), direction, dir])
			print("line_count=", line_count)
			for line in range(1, line_count + 1):
				bullet = BulletUtil.get_next_bullet(bullet_type)
				bullet.hitbox_layer = hitbox_layer
				per_bullet_f.call(bullet)
				bullet.move_type = move_type
				#print("firing[%s] - %s" % [line, dir.from_angle(dir.angle() + pattern_rot + (radians * line))])
				angle = (direction.angle() + pattern_rot + radians) + (radians * line)
				fire_origin = pos + (pattern_origin.from_angle(angle) * origin_offset)
				fire_direction = pos.from_angle(angle + (i * spread_rad) + ((fire_angle + fire_angle_modifier) * PI / 180))
				#print("%s, %s,%s" % [pattern_origin, origin, pattern_origin + origin.from_angle(angle) * origin_offset])
				if max_bounces > 0: bullet.max_bounces = max_bounces
				bullet._fire(fire_origin, fire_direction, bullet_shape, v, acceleration, max_velocity, shape_properties)


func set_ring(lines := 1, fire_ang := 0.0, spread_count := 1, spread_ang := 0.0, o_offset := 1, vel := 100, acceleration := 0, max_velocity := 500, f : Callable = func(bullet : Bullet = null): pass) -> void:
	line_count = lines
	fire_angle = fire_ang
	spread = spread_count if spread_count >= 1 else 1
	spread_degrees = spread_ang
	origin_offset = o_offset
	velocity = vel


func ring(lines := 1, fire_ang := 0.0, spread_count := 1, spread_ang := 0.0, o_offset := 1, vel := 100, acceleration := 0, max_velocity := 500, f : Callable = func(bullet : Bullet = null): pass) -> void:
	line_count = lines
	fire_angle = fire_ang
	spread = spread_count if spread_count >= 1 else 1
	spread_degrees = spread_ang
	origin_offset = o_offset
	velocity = vel
	#var pattern_origin := global_position
	pattern_origin = Vector2(global_position.x + (origin_offset * cos(360.0/line_count)), global_position.y + (origin_offset * sin(360.0/line_count)))
	#print("%s vs %s" % [pattern_origin, origin])
	# get spread angle
	var spread_rad : float = spread_degrees * PI / 180
	var dir_to_target : Vector2 = global_position.direction_to(target)
	# odd aims at target, even aims at the sides
	#var direction = dir_to_target.from_angle(dir_to_target.angle() + fire_angle) if spread % 2 != 0 else dir_to_target.from_angle(dir_to_target.angle() + fire_angle + (spread_rad / 2))
	var direction = dir_to_target if spread % 2 != 0 else dir_to_target.from_angle(dir_to_target.angle() + fire_angle + (spread_rad / 2))
	var radians : float = 2 * PI / line_count # convert to radians for function params
	f.call()
	# stacks
	for stack in range(1, stacks + 1):
		var v = velocity + (velocity * velocity_modifier * stack)
		# fire additional ring if should spread from a given line
		#print("%s - %s = %s" % [ceil(spread / 2.0), ceil(-spread / 2.0), ceil(spread / 2.0) - ceil(-spread / 2.0)])
		for i in range(ceil(-spread / 2.0), ceil(spread / 2.0)):
			var fire_direction : Vector2
			var angle : float
			var fire_origin : Vector2
			var bullet : Bullet
			#print("i=%s, %s, %s, %s" % [i, 1 + (i * spread_rad), direction, dir])
			for line in range(1, line_count + 1):
				bullet = BulletUtil.get_next_bullet(bullet_type)
				per_bullet_f.call(bullet)
				bullet.curve_angle = curve_angle if bullet_type == Bullet.MoveType.CURVE else 0
				bullet.move_type = move_type
				#print("firing[%s] - %s" % [line, dir.from_angle(dir.angle() + pattern_rot + (radians * line))])
				angle = (direction.angle() + pattern_rot + radians) + (radians * line)
				fire_origin = global_position + (pattern_origin.from_angle(angle) * origin_offset)
				fire_direction = global_position.from_angle(angle + (i * spread_rad) + ((fire_angle + fire_angle_modifier) * PI / 180))
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


func per_bullet(f : Callable = func(bullet : Bullet): pass) -> void:
	per_bullet_f = f


func wave(bullet : Bullet, frequency := 5.0, amplitude := 16.0, f : Callable = func(): pass) -> void:
	move_type = Bullet.MoveType.WAVE
	bullet.frequency = frequency
	bullet.amplitude = amplitude


func curve(bullet : Bullet, angle := 5.0, f : Callable = func(): pass) -> void:
	move_type = Bullet.MoveType.CURVE
	bullet.curve_angle = angle


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
