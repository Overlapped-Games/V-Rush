extends Node2D

var timer : Timer

func _ready():
	GameManager.visible_canvas(false)
	AudioManager.play_bgm("game_over")
	timer = Timer.new()
	timer.wait_time = 12.0
	timer.connect("timeout", _on_timeout)
	add_child(timer)
	timer.start()


func _input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventAction: return
	
	if Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_cancel"):
		timer.stop()
		_on_timeout()

func _on_timeout():
	get_tree().change_scene_to_file('res://assets/menus/scenes/main_menu.tscn')
