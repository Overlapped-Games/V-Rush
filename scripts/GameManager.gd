extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window : Window = get_tree().root
	window.size = Vector2(1280, 720)
