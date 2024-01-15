class_name Bullet extends Sprite2D


signal expired


enum MoveType {
	LINE,
	WAVE
}


@onready var shape : Shape2D = CircleShape2D.new()
@onready var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
@onready var direct_space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

@export var type := BulletUtil.BulletType.NON_DIRECTIONAL
@export var base_velocity := 100
@export var max_distance := 2400


@export_flags_2d_physics var hitbox_layer := 0b0010_0000_0000
@export_flags_2d_physics var grazebox_layer := 0b0001_0000_0000


#var sub_pos : Vector2
# used if want to move bullet to a given position before going towards target direction
var pre_position : Vector2

var max_velocity := 100
var velocity := base_velocity
var acceleration := 0

var direction : Vector2
var current_distance := 0.0

var camera : Cammaku
var screen_extents : Vector2

var active := false
var can_graze := true


func _ready() -> void:
	add_to_group("bullets")
	hide()
	set_physics_process(false)
	set_as_top_level(true)
	active = false
	
	velocity = base_velocity
	shape.set_radius(1)
	query.set_shape(shape)
	query.collide_with_areas = true
	query.collision_mask = hitbox_layer
	
	camera = get_tree().get_first_node_in_group("camera") as Cammaku
	
	screen_extents = get_viewport_rect().size / (2 * camera.zoom)
	#print("h=%s" % [screen_extents])
	
	
	#camera_area.area_exited.connect(_on_exited_screen)
	#PhysicsServer2D.area_set_monitor_callback(camera.area.get_rid(), func(status, area_rid, instance_id, area_shape_idx, self_shape_idx): print("huh - %s" % [status]))


func _physics_process(delta: float) -> void:
	#var distance := roundi(velocity * delta)
	velocity = clamp(velocity + acceleration, 0, max_velocity)
	var distance := velocity * delta
	var motion := direction * distance
	
	#sub_pos += motion
	#position = (sub_pos).round()
	global_position += motion
	current_distance += distance
	
	# disable if off screen
	if current_distance >= max_distance or global_position.y <= -(camera.global_position + screen_extents).y or global_position.y >= (camera.global_position + screen_extents).y or global_position.x <= -(camera.global_position + screen_extents).x or global_position.x >= (camera.global_position + screen_extents).x:
		##expired.emit(self)
		_disable()
		return
		
	query.collision_mask = hitbox_layer

	var hit := direct_space_state.intersect_shape(query, 1)
	# TODO: fix expire on reaching screen extents
	#var screen_extents := camera.position + (get_viewport_rect().size / 8)
	if hit:
		##expired.emit(self)
		var coll = hit[0]["collider"]
		#print_debug("colliding with %s" % [coll])
		coll._on_hit(self)
		_disable()
	else:
		query.collision_mask = grazebox_layer
		hit = direct_space_state.intersect_shape(query, 1)
		if hit and can_graze:
			can_graze = false
			var coll = hit[0]["collider"]
			coll._on_grazed()


func _fire() -> void:
	active = true
	show()
	set_physics_process(true)
	
	
func _initialize(origin : Vector2, target_direction : Vector2, vel := 100, accel := 0, max_vel := 500) -> void:
	global_position = origin
	query.transform = global_transform
	direction = target_direction
	current_distance = 0.0
	velocity = vel
	acceleration = accel
	max_velocity = max_vel


func _modify(f : Callable) -> void:
	f.call(self) # let callable do modifications to bullet


func _disable():
	expired.emit(self)
	hide()
	set_physics_process(false)
	active = false


func _swap(bullet_type : BulletUtil.BulletType) -> void:
	if type == bullet_type: return
	type = bullet_type
	texture = BulletUtil.BULLET_SPRITES[bullet_type]
