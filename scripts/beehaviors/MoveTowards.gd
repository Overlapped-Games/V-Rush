## Move towards a direction
@tool
class_name MoveTowards extends ActionLeaf


@onready var point : Marker2D = $point

@export var speed : int = 60

var camera : Camera2D
var direction : Vector2
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
	camera = get_tree().get_first_node_in_group("camera")
	target = actor.global_position + point.position 
	direction = (target - actor.global_position).normalized()
	print("dir=%s" % [direction])


func tick(actor: Node, blackboard: Blackboard) -> int:
	# Enemy went out of view left
	if actor.global_position.x < camera.position.x - 32 - camera.get_viewport_rect().size.x / 2:
		actor.queue_free()
		return SUCCESS
		
	actor.global_position += (direction * get_physics_process_delta_time() * speed)
	return RUNNING


