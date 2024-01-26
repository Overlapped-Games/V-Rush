class_name MoveTowardsPlayer extends ActionLeaf

@export var speed : int = 0

var camera : Camera2D
var screen_extents : Vector2
var direction : Vector2


# Cache player's position when the tree is activated
func before_run(actor : Node, blackboard : Blackboard) -> void:
	camera = get_tree().get_first_node_in_group("camera") as Camera2D
	screen_extents = camera.get_viewport_rect().size / (2 * camera.zoom)
	screen_extents.x += + 32
	var player : Player = get_tree().get_first_node_in_group("player")
	direction = (player.global_position - actor.global_position).normalized()
	print("dir=%s" % [direction])
 

func tick(actor : Node, blackboard : Blackboard) -> int:
	# Enemy went off screen, despawn
	if actor.global_position.y <= -(camera.global_position + screen_extents).y or actor.global_position.y >= (camera.global_position + screen_extents).y or actor.global_position.x <= -(camera.global_position + screen_extents).x or actor.global_position.x >= (camera.global_position + screen_extents).x:
		actor.queue_free()
		return SUCCESS
	
	actor.global_position += (direction * get_physics_process_delta_time() * (speed if speed > 0 else actor.speed))
	return RUNNING
