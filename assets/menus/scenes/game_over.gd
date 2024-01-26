extends Node2D

var timer

func _ready():
	GameManager.visible_canvas(false)
	AudioManager.play_bgm("game_over")
	timer = Timer.new()
	timer.wait_time = 11.0
	timer.connect("timeout", _on_TimerTimeout)
	add_child(timer)
	timer.start()

func _on_TimerTimeout():
	get_tree().change_scene_to_file('res://assets/menus/scenes/main_menu.tscn')
