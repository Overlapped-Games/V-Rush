extends Node2D

var fade_timer : Timer
var fade_duration : float = 1
var fade = false

func _ready():
	$Control/VBoxContainer/Play.grab_focus()
	# Create and connect the Timer
	fade_timer = Timer.new()
	add_child(fade_timer)
	connect("fade_timeout", play_menu_transition)

func _process(delta: float) -> void:
	if fade:
		fade_out(delta)

func fade_out(delta) -> void:
	if !self.modulate[3] <= 0:
		self.modulate[3] -= fade_duration * delta
	else:
		play_menu_transition()

func _on_play_pressed():
	fade = true

func play_menu_transition() -> void:
	#GameManager.visible_canvas()
	GameManager.visible_menu(false)
	get_tree().change_scene_to_file("res://assets/menus/scenes/transition.tscn")
	set_process(false)

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/menus/scenes/settings.tscn")


func _on_quit_pressed():
	get_tree().quit()
