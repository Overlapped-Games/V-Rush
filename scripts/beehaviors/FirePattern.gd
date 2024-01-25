@tool
class_name FirePattern extends ActionLeaf


@export var pattern : Danmaku


func tick(actor: Node, blackboard: Blackboard) -> int:
	pattern._start()
	print("%s firing" % [get_parent().get_parent().get_parent().name])
	return SUCCESS

