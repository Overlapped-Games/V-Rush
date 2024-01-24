# Part of the view that contains the camera and all other moving objects. The stage scrolls along the level, triggering any event triggers it runs into, etc 
class_name Stage extends Node2D

@export var speed : float = 100
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


func _ready() -> void:
	GameManager.init_stat()
	level_background.set_target_color(level_colors[GameManager.get_level() - 1])


func _physics_process(delta: float) -> void:
	position.x = roundi(position.x + 1 * delta * speed)
	
	#test wireframe modulation to the next level.
	#if Input.is_action_just_pressed("ui_accept"):
		#next_level()


func next_level():
	GameManager.set_level(GameManager.get_level() + 1)
	if GameManager.get_level() >= len(level_colors) - 1:
		GameManager.set_level(0)
	level_background.set_target_color(level_colors[GameManager.get_level() - 1])
