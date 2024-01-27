extends Node2D


var won := false


func _ready() -> void:
	set_process_input(false)


func _input(event):
	if !won: return
	if not event is InputEventKey and not event is InputEventAction and not event is InputEventJoypadButton and not event is InputEventJoypadMotion: return
	
	if Input.is_action_just_pressed("fire"):
		hide()
		get_tree().change_scene_to_file("res://assets/menus/scenes/main_menu.tscn")


func win() -> void:
	won = true
	set_process_input(true)
