extends Node2D

var level_one_color : Color = Color(0.00, 0.75, 1.00, 1)

func _ready() -> void:
	%LevelBackground.modulate = Color(0, 0, 0, 0)
	%LevelBackground.set_target_color(level_one_color)
	get_tree().create_timer(2.5).timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	GameManager.visible_canvas(true)
	get_tree().change_scene_to_file("res://assets/levels/stage_1.tscn")
