extends Node2D

#func _input(event) -> void:
	#if event is InputEventKey:
		## Check if a key was pressed
		#if event.is_pressed() and event.keycode == KEY_ESCAPE:
			#_on_button_pressed()
#
#func _on_button_pressed():
	## Change the scene to another scene or the same scene
	#get_tree().change_scene_to_file("res://assets/menus/scenes/main_menu.tscn")
