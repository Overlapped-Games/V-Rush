extends Node2D

var fade_timer : Timer
var fade_duration : float = 1
var fade = false

func _ready() -> void:
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

func _on_play_pressed() -> void:
	fade = true

func play_menu_transition() -> void:
	get_tree().change_scene_to_file("res://assets/menus/scenes/transition.tscn")
	
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/menus/scenes/settings.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()

# --------- mouse hover event ------------
func _on_play_shader_mouse_entered() -> void:
	$Control/PlayShader.visible = false
func _on_play_shader_mouse_exited() -> void:
	$Control/PlayShader.visible = true
func _on_settings_shader_mouse_entered() -> void:
	$Control/SettingsShader.visible = false
func _on_settings_shader_mouse_exited() -> void:
	$Control/SettingsShader.visible = true
func _on_quit_shader_mouse_entered() -> void:
	$Control/QuitShader.visible = false
func _on_quit_shader_mouse_exited() -> void:
	$Control/QuitShader.visible = true
# ----------------------------------------
