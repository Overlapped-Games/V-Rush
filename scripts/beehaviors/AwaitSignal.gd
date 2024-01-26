class_name AwaitSignal extends ActionLeaf

@export var node : Node
@export var signal_name : String

var success : bool = false
	
	
func _ready() -> void:
	success = false
	node.get(signal_name).connect(_on_signal_emitted)

	
func tick(actor : Node, blackboard : Blackboard) -> int:
	if !node.has_signal(signal_name):
		return FAILURE
		
	if success: 
		success = false # reset upon success
		return SUCCESS
	return RUNNING

	
func _on_signal_emitted() -> void:
	success = true
