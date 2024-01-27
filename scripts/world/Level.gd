class_name Level extends Node2D


@export var level : int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#%level_trigger.connect("next_level", spawn_new_level)
	AudioManager.play_bgm("stage_1")
	GameManager.process = true

#func _process(_de lta):
	#if GameManager.player_dead:
		#self.queue_free()


func remove_all_enemies():
	for child in get_children():
		if child.name.begins_with("MoveTrigger"):
			child.queue_free()


func add_new_enemies():
	var stage_scene = preload("res://assets/levels/stage_2.tscn")
	var stage_instance = stage_scene.instantiate()
	for child in stage_instance.get_children():
		if child.name.begins_with("MoveTrigger") or child.name.begins_with("EventTrigger"):
			var duplicate = child.duplicate()
			add_child(duplicate)
	 
	
func spawn_new_level():
	remove_all_enemies()
	var current_level = GameManager.get_level()
	add_new_enemies()
