class_name PlaySFX extends ActionLeaf

@export var sfx_name : String

func tick(actor: Node, blackboard: Blackboard) -> int:
	AudioManager.play_sfx(sfx_name)
	return SUCCESS

