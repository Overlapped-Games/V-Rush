class_name FirePattern extends ActionLeaf


@export var pattern : Node


func tick(actor: Node, blackboard: Blackboard) -> int:
	pattern.fire()
	#print("%s firing" % [get_parent().get_parent().get_parent().name])
	blackboard.set_value("fired", true)
	return SUCCESS

