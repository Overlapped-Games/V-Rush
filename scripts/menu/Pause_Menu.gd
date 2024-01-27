extends Node2D


func _input(event):
	if not event is InputEventKey and not event is InputEventAction and not event is InputEventJoypadButton and not event is InputEventJoypadMotion: return
	
	if Input.is_action_just_pressed("escape_menu"):
		toggle_pause_menu()


func toggle_pause_menu():
	if get_tree().paused:
		hide()
		get_tree().paused = false
	else:
		get_tree().paused = true
		show()
