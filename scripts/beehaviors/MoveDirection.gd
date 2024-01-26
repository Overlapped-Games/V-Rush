class_name MoveDirection extends ActionLeaf


@export var speed : int = 0
@export_enum("Up", "Down", "Left", "Right") var direction : int = 2

var camera : Camera2D

var dir : Vector2

func before_run(actor: Node, blackboard: Blackboard) -> void:
	camera = get_tree().get_first_node_in_group("camera")
	var d : Vector2 = Vector2.UP if direction == 0 else Vector2.DOWN if direction == 1 else Vector2.LEFT if direction == 2 else Vector2.RIGHT
	dir = (actor.global_position).direction_to(actor.global_position + d)
 

func tick(actor: Node, blackboard: Blackboard) -> int:
	# Enemy went out of view left
	if actor.global_position.x < camera.global_position.x - 32 - camera.get_viewport_rect().size.x / 2:
		actor.queue_free()
		return SUCCESS
	
	actor.global_position += (dir * get_physics_process_delta_time() * (speed if speed > 0 else actor.speed))
	return RUNNING



