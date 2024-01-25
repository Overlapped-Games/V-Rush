## Move towards a direction
class_name MoveTowards extends ActionLeaf

@export var speed : int = 60
@export var target : Node2D

var camera : Camera2D
var direction : Vector2


func _ready() -> void:
	var old_transform = target.global_transform
	target.set_as_top_level(true)
	target.transform = old_transform


func before_run(actor: Node, blackboard: Blackboard) -> void:
	camera = get_tree().get_first_node_in_group("camera")
	direction = (target.global_position - actor.global_position).normalized()
	print("dir=%s" % [direction])
 

func tick(actor: Node, blackboard: Blackboard) -> int:
	# Enemy went out of view left
	if actor.global_position.x < camera.global_position.x - 32 - camera.get_viewport_rect().size.x / 2:
		actor.queue_free()
		return SUCCESS
	
	actor.global_position += (direction * get_physics_process_delta_time() * speed)
	return RUNNING


