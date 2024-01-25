## Move to a position in space
class_name MoveToPoint extends ActionLeaf


@export var speed : int = 60
@export var target : Node2D


func _ready() -> void:
	var old_transform = target.global_transform
	target.set_as_top_level(true)
	target.transform = old_transform


func before_run(actor: Node, blackboard: Blackboard) -> void:
	print("aa %s, %s" % [actor.global_position, target.global_position])


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.global_position.distance_to(target.global_position) < 1:
		actor.global_position = target.global_position
		return SUCCESS
		
	actor.global_position += ((target.global_position - actor.global_position).normalized() * get_physics_process_delta_time() * speed)
	return RUNNING

