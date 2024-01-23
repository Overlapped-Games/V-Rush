@tool
class_name EventTrigger extends Area2D

@onready var area : Area2D = $Area2D


func _ready() -> void:
	area.collision_layer = 0b0010_0000_0000_0000
	area.collision_mask = 0b0001_0000_0000_0000
	area_entered.connect(_on_camera_entered)


func _on_camera_entered(area : Area2D) -> void:
	print("event")
	$Event._trigger()
	$CollisionShape2D.disabled = true
