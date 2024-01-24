## Move to a position in space
@tool
class_name MoveToPoint extends ActionLeaf

@onready var point : Marker2D = $point

@export var speed : int = 60

var target : Vector2

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	
	var children: Array[Node] = get_children()

	if children.any(func(x): return x is BeehaveNode):
		warnings.append("Leaf nodes should not have any child nodes. They won't be ticked.")
	
	for source in _get_expression_sources():
		var error_text: String = _parse_expression(source).get_error_text()
		if not error_text.is_empty():
			warnings.append("Expression `%s` is invalid! Error text: `%s`" % [source, error_text])
			
	if !has_node("point"):
		warnings.append("Must have a child Marker2D named 'point'")
	
	if not get_node("point") is Marker2D:
		warnings.append("Child 'point' must be a Marker2D")

	return warnings
	

func before_run(actor: Node, blackboard: Blackboard) -> void:
	point.set_as_top_level(true)
	print("%s, %s" % [actor.global_position, point.global_position])
	#target = actor.global_position + point.global_position 


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.global_position.distance_to(point.global_position) < 1:
		actor.global_position = point.global_position
		return SUCCESS
		
	actor.global_position += ((point.global_position - actor.global_position).normalized() * get_physics_process_delta_time() * speed)
	return RUNNING

