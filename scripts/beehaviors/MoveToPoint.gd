## Move to a position in space
class_name MoveToPoint extends ActionLeaf


@export var speed : int = 0
@export var target : Node2D
@export var reparent : bool = false



func before_run(actor: Node, blackboard: Blackboard) -> void:
	if reparent:
		var target_pos : Vector2 = target.global_position
		#var old_transform = target.global_transform
		target.set_as_top_level(true)
		target.global_position = target_pos
		#print("aa %s, %s" % [actor.global_position, target.global_position])


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.global_position.distance_to(target.global_position) <= 1.5:
		actor.global_position = target.global_position
		return SUCCESS
		
	actor.global_position += ((target.global_position - actor.global_position).normalized() * get_physics_process_delta_time() * (speed if speed > 0 else actor.speed))
	return RUNNING

