extends Control

var buttons : Array = []  # Array to store button nodes
var focusedIndex : int = 0  # Index of the currently focused button
@onready var play_shader = $PlayShader
@onready var settings_shader = $SettingsShader
@onready var quit_shader = $QuitShader

func _ready():
	# Populate the buttons array with all Button nodes inside the VBoxContainer
	for child in get_node("VBoxContainer").get_children():
		if child is Button:
			buttons.append(child)

	# Set initial focus to the first button
	print(buttons)
	buttons[focusedIndex].grab_focus()
	move_focus(0)

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


func _input(event: InputEvent) -> void:
	if event is InputEventAction or event is InputEventKey or event is InputEventMouseButton:
		var just_pressed = event.is_pressed() and not event.is_echo()
		if Input.is_key_pressed(KEY_DOWN) and just_pressed:
			move_focus(1)
		elif Input.is_key_pressed(KEY_UP):
			move_focus(-1)


func move_focus(direction: int):
	focusedIndex += direction
	focusedIndex = wrapf(focusedIndex, 0, buttons.size())
	change()
