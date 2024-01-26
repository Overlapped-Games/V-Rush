## Scrolls the enemies and powerups by while the camera stays stationary. This is to prevent bullets from dragging or speeding up due to the camera moving
class_name Scroller extends Node2D

@export var auto_scrolling : bool = true
@export var speed : float = 30


func _ready() -> void:
	set_physics_process(auto_scrolling)


func _physics_process(delta: float) -> void:
	if !auto_scrolling: return
	position.x = roundi(position.x - 1 * delta * speed)


func _stop() -> void:
	auto_scrolling = false
	set_physics_process(false)
