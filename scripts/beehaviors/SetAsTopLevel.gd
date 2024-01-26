class_name SetAsTopLevel extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor is Node2D:
		actor.set_as_top_level(true)
		return SUCCESS
	return FAILURE

