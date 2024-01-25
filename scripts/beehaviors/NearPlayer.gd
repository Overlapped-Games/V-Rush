class_name NearPlayer extends ActionLeaf


@export var radius : int = 200


var player : Player


func before_run(actor: Node, blackboard: Blackboard) -> void:
	player = get_tree().get_first_node_in_group("player")


func tick(actor: Node, blackboard: Blackboard) -> int:
	return SUCCESS if player.global_position.distance_to(actor.global_position) <= radius else RUNNING

