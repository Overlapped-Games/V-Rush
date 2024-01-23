extends Node2D

var fade_timer : Timer
var fade_duration : float = 0.05
var fade = false

func _ready():
	$Control/VBoxContainer/Play.grab_focus()
	
	# Create and connect the Timer
	fade_timer = Timer.new()
	add_child(fade_timer)
	connect("fade_timeout", _on_fade_timeout)

func _process(delta: float) -> void:
	if fade:
		fade_out()

func fade_out() -> void:
	if !self.modulate[3] <= 0:
		self.modulate[3] -= fade_duration
	else:
		pass
		#call level one transition.

func _on_play_pressed():
	fade = true

func _on_fade_timeout() -> void:
	get_tree().change_scene_to_file("res://scripts/godonmaku/danmaku_tester.tscn")


func _on_quit_pressed():
	get_tree().quit()
