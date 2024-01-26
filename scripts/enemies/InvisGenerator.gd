class_name InvisGenerator extends Node2D


@export var danmaku : Danmaku


var camera : Camera2D
var screen_extents : Vector2


func _ready() -> void:
	camera = get_tree().get_first_node_in_group("camera") as Camera2D
	screen_extents = camera.get_viewport_rect().size / (2 * camera.zoom)
	screen_extents.x += + 32


func _start() -> void:
	for child in get_children().filter(func(child): return child is BeehaveTree):
		child.enabled = true


func _physics_process(delta: float) -> void:
	if global_position.y <= -(camera.global_position + screen_extents).y or global_position.y >= (camera.global_position + screen_extents).y or global_position.x <= -(camera.global_position + screen_extents).x or global_position.x >= (camera.global_position + screen_extents).x:
		queue_free()
