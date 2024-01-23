class_name WaitTimed extends ActionLeaf


@export var frames : int = 60


var t : float = 0.0


func tick(actor: Node, blackboard: Blackboard) -> int:
	t += 60.0 / frames
	if t >= 60:
		t = 0
		return SUCCESS
	return RUNNING

