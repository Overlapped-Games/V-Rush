@tool
class_name EventTrigger extends Area2D


@onready var collider : CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	collision_layer = 0b0010_0000_0000_0000
	collision_mask = 0b0001_0000_0000_0000
	area_entered.connect(_on_camera_entered)


func _on_camera_entered(area : Area2D) -> void:
	# Trigger any event children attached to this node
	for child in get_children():
		if not child is Event: continue
		child._trigger()
	$CollisionShape2D.disabled = true
