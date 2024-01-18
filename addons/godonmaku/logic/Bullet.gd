class_name Bullet extends Sprite2D


signal expired


enum Type {
	PLAYER,
	ENEMY
}


enum MoveType {
	LINE,
	WAVE
}


enum FiringState {
	MOVE = 0b01,
	FIRE = 0b10
}


@onready var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()

@export var damage := 10
@export var type := Type.ENEMY
@export var bullet_type := BulletUtil.BulletType.NON_DIRECTIONAL
@export var base_velocity := 100
@export var max_distance := 2400
@export var properties := {}

@export_flags_2d_physics var hitbox_layer := 0b0010_0000_0000
@export_flags_2d_physics var grazebox_layer := 0b0001_0000_0000


#var sub_pos : Vector2
# used if want to move bullet to a given position before going towards target direction
var pre_position : Vector2

var max_velocity := 1000
var velocity := base_velocity
var acceleration := 0
var t := 0.0

var max_bounces := 0
var current_bounces := 0

var direction : Vector2
var current_distance := 0.0

var target_position : Vector2
var move_direction : Vector2

var camera : Cammaku
var screen_extents : Vector2

var firing_state := FiringState.FIRE
var moving := false
var active := false
var can_graze := true

var player : Player

func _ready() -> void:
	add_to_group("bullets")
	hide()
	set_physics_process(false)
	set_as_top_level(true)
	active = false
	
	velocity = base_velocity
	#circle.set_radius(radius)
	query.collide_with_areas = true
	query.collision_mask = hitbox_layer
	
	camera = get_tree().get_first_node_in_group("camera") as Cammaku
	
	screen_extents = get_viewport_rect().size / (2 * camera.zoom)
	#print("h=%s" % [screen_extents])
	
	player = get_tree().get_first_node_in_group("player")
	
	#camera_area.area_exited.connect(_on_exited_screen)
	#PhysicsServer2D.area_set_monitor_callback(camera.area.get_rid(), func(status, area_rid, instance_id, area_shape_idx, self_shape_idx): print("huh - %s" % [status]))


func _physics_process(delta: float) -> void:
	velocity = clamp(velocity + acceleration, 0, max_velocity)
	var distance := velocity * delta
	var motion := direction * distance
	
	#sub_pos += motion
	#position = (sub_pos).round()
	global_position += motion
	current_distance += distance
	
	#global_position += direction * velocity * delta
	#current_distance += velocity * delta
	
	
	# disable if reached max distance
	if current_distance >= max_distance:
		_disable()
		return
		
	# handle off screen
	if global_position.y <= -(camera.global_position + screen_extents).y or global_position.y >= (camera.global_position + screen_extents).y or global_position.x <= -(camera.global_position + screen_extents).x or global_position.x >= (camera.global_position + screen_extents).x:
		##expired.emit(self)
		if max_bounces > 0 and current_bounces < max_bounces:
			if global_position.y <= -(camera.global_position + screen_extents).y or global_position.y >= (camera.global_position + screen_extents).y:
				direction = Vector2(direction.x, -direction.y)
			elif global_position.x <= -(camera.global_position + screen_extents).x or global_position.x >= (camera.global_position + screen_extents).x:
				direction = Vector2(-direction.x, direction.y)
			current_bounces += 1
		else:
			_disable()
		return
		
	

	#if global_position.distance_squared_to(player.global_position) <= 32:
		##print("CLOSE")
		#player._on_hit(self)
		#_disable()
		
	query.collision_mask = hitbox_layer
	query.transform = global_transform
	var hit : Array[Dictionary] = BulletUtil.intersect_shape(query, 1)
	# TODO: fix expire on reaching screen extents
	if hit:
		##expired.emit(self)
		var coll : Node2D = hit[0]["collider"]
		#print_debug("colliding with %s" % [coll])
		
		#print("rest_info=%s" % [BulletUtil.direct_space_state.get_rest_info(query)])
		if coll.has_method("_on_hit"):
			coll._on_hit(self)
		_disable()
	else:
		if type == Type.ENEMY:
			query.collision_mask = grazebox_layer
			hit = BulletUtil.intersect_shape(query, 1)
			if hit and can_graze:
				can_graze = false
				var coll = hit[0]["collider"]
				coll._on_grazed()


func move_wave(delta : float, period := 1.0, amplitude := 1.0, frequency := 1.0) -> void:
	velocity = clamp(velocity + acceleration, 0, max_velocity)
	amplitude * sin(frequency * period * velocity * delta)
	var distance := velocity * delta
	var motion := direction * distance
	
	#sub_pos += motion
	#position = (sub_pos).round()
	global_position += motion
	current_distance += distance


func move_straight(delta : float) -> void:
	velocity = clamp(velocity + acceleration, 0, max_velocity)
	t += delta
	var distance := velocity * delta
	var motion := direction * distance
	
	#sub_pos += motion
	#position = (sub_pos).round()
	global_position += motion
	current_distance += distance


# Useful for moving bullet to a position before actually firing
# target position is relative to direction
func _move(origin : Vector2, target_direction : Vector2,  target_position : Vector2, bullet_shape : BulletUtil.BulletShape, shape_properties : Dictionary, vel := 100, max_vel := 1000) -> void:
	firing_state |= FiringState.MOVE
	moving = true
	global_position = origin
	query.set_shape(BulletUtil.get_bullet_shape(bullet_shape, shape_properties))
	current_distance = 0.0
	velocity = vel
	max_velocity = max_vel
	show()


func _fire(origin : Vector2, target_direction : Vector2, bullet_shape : BulletUtil.BulletShape, vel := 100, accel := 0, max_vel := 1000, shape_properties := {}) -> void:
	firing_state |= FiringState.FIRE
	active = true
	global_position = origin
	direction = target_direction
	query.collision_mask = hitbox_layer
	query.set_shape(BulletUtil.get_bullet_shape(bullet_shape, shape_properties if !shape_properties.is_empty() else properties))
	current_distance = 0.0
	velocity = vel
	acceleration = accel
	max_velocity = max_vel
	show()
	set_physics_process(true)


func _move_and_fire(origin : Vector2, move_direction : Vector2,  target_position : Vector2, fire_direction : Vector2, bullet_shape : BulletUtil.BulletShape, shape_properties : Dictionary, move_vel := 100, fire_vel := 100) -> void:
	pass


#func _initialize(origin : Vector2, target_direction : Vector2, bullet_shape : BulletUtil.BulletShape, shape_properties : Dictionary, vel := 100, accel := 0, max_vel := 1000) -> void:
	#global_position = origin
	#direction = target_direction
	#query.collision_mask = hitbox_layer
	##var circle = CircleShape2D.new()
	##circle.radius = 4
	##query.set_shape(circle)
	#query.set_shape(BulletUtil.get_bullet_shape(bullet_shape, shape_properties))
	#current_distance = 0.0
	#velocity = vel
	#acceleration = accel
	#max_velocity = max_vel


#func _modify(f : Callable) -> void:
	#f.call(self) # let callable do modifications to bullet


func _disable():
	expired.emit(self)
	hide()
	set_physics_process(false)
	active = false


func _swap(bullet_type : BulletUtil.BulletType) -> void:
	if bullet_type == bullet_type: return
	bullet_type = bullet_type
	texture = BulletUtil.BULLET_SPRITES[bullet_type]
