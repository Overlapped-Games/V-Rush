class_name MoveTrigger extends Node2D

@onready var area : Area2D = $Area
@onready var collider : CollisionShape2D = $Area/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.collision_layer = 0b0010_0000_0000_0000
	area.collision_mask = 0b0001_0000_0000_0000
	area.area_entered.connect(_on_entered_view)


func _on_entered_view(area : Area2D) -> void:
	for i in range(1, get_child_count()):
		var child : Node2D = get_child(i)
		if child.has_method("_start"):
			child._start()
	$CollisionShape2D.disabled = true
