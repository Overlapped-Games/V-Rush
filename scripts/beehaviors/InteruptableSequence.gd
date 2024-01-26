class_name InteruptableSequence extends SequenceComposite


var stop_seq : bool = false


func tick(actor: Node, blackboard: Blackboard) -> int:
	if stop_seq: return SUCCESS
	return super.tick(actor, blackboard)


func stop() -> void:
	stop_seq = true
