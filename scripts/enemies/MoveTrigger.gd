class_name MoveTrigger extends Node2D

@onready var area : Area2D = $Area
@onready var collider : CollisionShape2D = $Area/CollisionShape2D

var stage : Stage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.collision_layer = 0b0010_0000_0000_0000
	area.collision_mask = 0b0001_0000_0000_0000
	area.area_entered.connect(_on_entered_view)
	stage = get_tree().get_first_node_in_group("stage")
	print('im new')


func _on_entered_view(area : Area2D) -> void:
	print_debug("get_child_count()%s, %s" % [get_child_count(), get_children()])
	while get_child_count() > 1:
		var child : Node2D = get_child(1)
		#print_debug("c[%s]" % [1])
		if !child: return
		if child.has_method("_start"):
			print_debug("_s[%s]" % [1])
			child._start() 
			child.reparent(stage)
	collider.disabled = true
