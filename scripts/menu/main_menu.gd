class_name MainMenu extends Node2D

var fade_timer : Timer
var fade_duration : float = 1
var fade = false
signal play()

func _ready() -> void:
	fade_timer = Timer.new()
	add_child(fade_timer)
	connect("fade_timeout", play_menu_transition)
	%Selector.option_selected.connect(_on_option_selected)
	AudioManager.call_deferred("play_bgm", "main_menu")


func _process(delta: float) -> void:
	if fade:
		fade_out(delta)


func fade_out(delta) -> void:
	if !self.modulate[3] <= 0:
		self.modulate[3] -= fade_duration * delta
	else:
		play_menu_transition()


func play_menu_transition() -> void:
	#GameManager.visible_menu(false)
	hide()
	get_tree().change_scene_to_file("res://assets/menus/scenes/transition.tscn")
	set_process(false)


func _on_option_selected(index : int) -> void:
	match index:
		0:
			fade = true
			%Selector.set_process_input(false) # stop selector from handling inputs
			play.emit()
			AudioManager.fade_bgm()
		1:
			%SettingsMenu.show()
			%Options.hide()
		2:
			get_tree().quit()

func _on_play_pressed() -> void:
	fade = true

func _on_settings_pressed() -> void:
	%SettingsMenu.show()
	%Options.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()
