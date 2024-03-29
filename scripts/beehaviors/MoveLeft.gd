class_name MoveLeft extends ActionLeaf


@export var speed : int = 0

var camera : Camera2D


func before_run(actor: Node, blackboard: Blackboard) -> void:
	camera = get_tree().get_first_node_in_group("camera")


func tick(actor: Node, blackboard: Blackboard) -> int:
	# Enemy went out of view left
	if actor.global_position.x < camera.global_position.x - 32 - camera.get_viewport_rect().size.x / 2:
		actor.queue_free()
		return SUCCESS
		
	actor.global_position.x += (Vector2.LEFT.x * get_physics_process_delta_time() * (speed if speed > 0 else actor.speed))
	return RUNNING
