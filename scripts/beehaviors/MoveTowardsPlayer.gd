class_name MoveTowardsPlayer extends ActionLeaf

@export var speed : int = 60

var camera : Camera2D
var direction : Vector2


# Cache player's position when the tree is activated
func before_run(actor: Node, blackboard: Blackboard) -> void:
	camera = get_tree().get_first_node_in_group("camera")
	var player : Player = get_tree().get_first_node_in_group("player")
	direction = (player.global_position - actor.global_position).normalized()
	print("dir=%s" % [direction])
 

func tick(actor: Node, blackboard: Blackboard) -> int:
	# Enemy went out of view left
	if actor.global_position.x < camera.global_position.x - 32 - camera.get_viewport_rect().size.x / 2:
		actor.queue_free()
		return SUCCESS
	
	actor.global_position += (direction * get_physics_process_delta_time() * speed)
	return RUNNING
