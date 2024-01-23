extends Node2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		load_scene("res://assets/menus/scenes/main_menu.tscn")


func load_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
