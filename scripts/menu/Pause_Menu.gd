extends Node2D

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_P:
			toggle_pause_menu()
func toggle_pause_menu():
	if get_tree().paused:
		get_tree().paused = false
		#$PauseMenu.hide()
	else:
		get_tree().paused = true
		#$PauseMenu.show()
