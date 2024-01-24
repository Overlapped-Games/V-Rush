# Part of the view that contains the camera and all other moving objects. The stage scrolls along the level, triggering any event triggers it runs into, etc 
class_name Stage extends Node2D


@export var speed : float = 100


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	position.x = roundi(position.x + 1 * delta * speed)
