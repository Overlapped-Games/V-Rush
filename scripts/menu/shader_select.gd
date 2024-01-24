extends Control

var buttons : Array = []  # Array to store button nodes
var focusedIndex : int = 0  # Index of the currently focused button
@onready var play_shader = $PlayShader
@onready var settings_shader = $SettingsShader
@onready var quit_shader = $QuitShader
@onready var menu_select_sound = $Menu_select
@onready var menu_back_sound = $Menu_back
@onready var menu_up_down_sound = $"Menu_up-down"
var sleep_timer : Timer

func _ready():
	sleep_timer = Timer.new()  # Initialize the sleep timer
	sleep_timer.connect("timeout", _on_sleep_timer_timeout)
	sleep_timer.wait_time = 1
	add_child(sleep_timer)  # Add the sleep timer as a child of the Control node

	for child in get_node("VBoxContainer").get_children():
		if child is Button:
			buttons.append(child)

	buttons[focusedIndex].grab_focus()
	move_focus(0)

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
		elif Input.is_key_pressed(KEY_UP):
			move_focus(-1)
			menu_up_down_sound.play()
		if Input.is_action_just_pressed("ui_accept"):
			sleep_timer.start()  # Start the sleep timer when a button is selected
			menu_select_sound.play()
		if Input.is_action_just_pressed("ui_cancel"):
			menu_back_sound.play()
			$"../Settings".visible = false

func move_focus(direction: int):
	focusedIndex += direction
	focusedIndex = wrapf(focusedIndex, 0, buttons.size())
	change()

func change() -> void:
	match focusedIndex:
		0:
			show_play_shader()
			hide_settings_shader()
			hide_quit_shader()
		1:
			hide_play_shader()
			show_settings_shader()
			hide_quit_shader()
		2:
			hide_play_shader()
			hide_settings_shader()
			show_quit_shader()

func show_play_shader() -> void:
	play_shader.visible = true

func hide_play_shader() -> void:
	play_shader.visible = false

func show_settings_shader() -> void:
	settings_shader.visible = true

func hide_settings_shader() -> void:
	settings_shader.visible = false

func show_quit_shader() -> void:
	quit_shader.visible = true

func hide_quit_shader() -> void:
	quit_shader.visible = false

func _notification(notification: int) -> void:
	if notification == NOTIFICATION_EXIT_TREE:
		sleep_timer.queue_free()  # Remove the sleep timer when exiting the scene
