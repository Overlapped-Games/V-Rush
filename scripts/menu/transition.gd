extends Node2D

var level_one_color : Color = Color(0.00, 0.75, 1.00, 1)
var timer : Timer

func _ready() -> void:
	$WhiteBackground/WireFrameBg.modulate = Color(0, 0, 0, 0)
	$WhiteBackground/WireFrameBg.set_target_color(Color(0.00, 0.75, 1.00, 1))
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 2.5
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	GameManager.visible_canvas(true)
	get_tree().change_scene_to_file("res://assets/levels/stage_1.tscn")
	#get_tree().change_scene_to_file("res://scripts/godonmaku/danmaku_tester.tscn")
