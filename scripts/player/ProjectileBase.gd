class_name ProjectileBase extends Node2D


signal expired


@onready var shape : Shape2D = CircleShape2D.new()
@onready var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
@onready var direct_space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state


@export var base_velocity := 100
@export var max_distance := 2400
@export var radius := 4

var direction : Vector2
var current_distance := 0.0
var active := false
var velocity := 1

# Should only be called once weapon is started
var player_stats : Stats:
	set(value):
		player_stats = value
		player_stats.stats_changed.connect(_on_stats_changed)
		_on_stats_changed(player_stats)

var camera : Cammaku
var screen_extents : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	set_physics_process(false)
	set_as_top_level(true)
	active = false
	shape.set_radius(radius)
	query.set_shape(shape)
	#query.collide_with_areas = true
	#query.collide_with_bodies = false
	query.collision_mask = 0b0000_0100
	
	print("h=%s" % [screen_extents])
	
	camera = get_tree().get_first_node_in_group("camera")
	screen_extents = get_viewport_rect().size / (2 * camera.zoom)
	
	#camera_area.area_exited.connect(_on_exited_screen)
	PhysicsServer2D.area_set_monitor_callback(camera.area.get_rid(), func(status, area_rid, instance_id, area_shape_idx, self_shape_idx): print("huh - %s" % [status]))


func _physics_process(delta : float) -> void:
	var distance := roundi(velocity * delta)
	var motion := direction * distance
	#print("d=%s,m=%s" % [distance, motion])
	
	position = (position + motion).snapped(Vector2.ONE)
	current_distance += distance
	query.transform = global_transform
	#print("current_distance=%s, %s, %s" % [current_distance, position, camera.position + screen_extents])
	
	var result := direct_space_state.intersect_shape(query, 1)
	# TODO: fix expire on reaching screen extents
	#var screen_extents := camera.position + (get_viewport_rect().size / 8)
	if result or current_distance >= max_distance or position.y <= -(camera.position + screen_extents).y or position.y >= (camera.position + screen_extents).y or position.x <= -(camera.position + screen_extents).x or position.x >= (camera.position + screen_extents).x:
		expired.emit(self)
		_disable()
		if result:
			var coll = result[0]["collider"]
			if !coll.has_method("_on_projectile_collide"): return
			coll._on_projectile_collide(self, player_stats.attack)


func _fire(origin : Vector2, target_direction : Vector2) -> void:
	global_position = origin
	direction = target_direction
	current_distance = 0.0
	active = true
	show()
	set_physics_process(true)


func _disable():
	hide()
	set_physics_process(false)
	active = false


func _on_stats_changed(stats : Stats) -> void:
	velocity = base_velocity * stats.velocity


func _on_exited_screen():
	expired.emit(self)
	_disable()
