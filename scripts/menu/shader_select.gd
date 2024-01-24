extends MarginContainer


signal option_selected(index : int)


@onready var play_shader = $Options/Play/PlayShader
@onready var settings_shader = $Options/Settings/SettingsShader
@onready var quit_shader = $Options/Quit/QuitShader
@onready var menu_select_sound = $Menu_select
@onready var menu_back_sound = $Menu_back
@onready var menu_up_down_sound = $"Menu_up-down"

#var buttons : Array = []  # Array to store button nodes
var focused_index : int = 0  # Index of the currently focused button
var sleep_timer : Timer

var curr_option : Control


func _ready():
	sleep_timer = Timer.new()  # Initialize the sleep timer
	sleep_timer.connect("timeout", _on_sleep_timer_timeout)
	sleep_timer.wait_time = 1
	add_child(sleep_timer)  # Add the sleep timer as a child of the Control node

	#for child in %Options.get_children():
		#if child is Button:
			#buttons.append(child)

	#buttons[focused_index].grab_focus()
	curr_option = %Play
	move_focus(0)


func _exit_tree() -> void:
	sleep_timer.queue_free()  # Remove the sleep timer when exiting the scene


func _on_sleep_timer_timeout():
	menu_back_sound.volume_db = -80  # Reset volume when sleep timer expires
	menu_select_sound.volume_db = -80
	menu_up_down_sound.volume_db = -80


func _input(event: InputEvent) -> void:
	if event is InputEventAction or event is InputEventKey or event is InputEventMouseButton:
		var just_pressed = event.is_pressed() and not event.is_echo()
		if Input.is_key_pressed(KEY_DOWN) and just_pressed:
			move_focus(1)
			menu_up_down_sound.play()
		elif Input.is_key_pressed(KEY_UP) and just_pressed:
			move_focus(-1)
			menu_up_down_sound.play()
		elif Input.is_action_just_pressed("ui_accept"):
			sleep_timer.start()  # Start the sleep timer when a button is selected
			menu_select_sound.play()
			option_selected.emit(focused_index)
		elif Input.is_action_just_pressed("ui_cancel"):
			menu_back_sound.play()
			%SettingsMenu.hide()
			%Options.show()


func move_focus(direction : int):
	curr_option.get_child(0).hide()
	curr_option.get_child(1).hide()
	focused_index = wrapi(focused_index + direction, 0, %Options.get_child_count())
	curr_option = %Options.get_child(focused_index)
	curr_option.get_child(0).show()
	curr_option.get_child(1).show()
