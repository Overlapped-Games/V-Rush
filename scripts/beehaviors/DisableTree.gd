class_name DisableTree extends ActionLeaf

@export var beehave_tree : BeehaveTree


func tick(actor: Node, blackboard: Blackboard) -> int:
	beehave_tree.enabled = false
	return SUCCESS

