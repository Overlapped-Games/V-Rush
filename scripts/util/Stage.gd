# Part of the view that contains the camera and characters. Stays staionary while the scroller moves towards the stage, bringing along enemies and triggering any event triggers it runs into, etc 
class_name Stage extends Node2D

@export var level_colors : Array = [
	Color(0.00, 0.75, 1.00),
	Color(1.00, 0.20, 0.50),
	Color(1.00, 0.40, 0.20),
	Color(1.00, 0.80, 0.00),
	Color(0.00, 1.00, 0.50),
	Color(1.00, 0.10, 0.00),
	Color(1.00, 1.00, 0.00),
]
@onready var level_background = %LevelBackground



func next_level():
	GameManager.set_level(GameManager.get_level() + 1)
	if GameManager.get_level() >= len(level_colors) - 1:
		GameManager.set_level(0)
	level_background.set_target_color(level_colors[GameManager.get_level() - 1])


func _stop() -> void:
	set_physics_process(false)
