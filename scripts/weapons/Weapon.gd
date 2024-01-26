class_name Weapon extends Node2D

@export var attack_rate := 10

#var active_projectiles := 0
var t_fire := 0.0
var t_fire_3 := 0.0
var can_fire := true
var can_fire_3 := true
var stage : int = 1


func _start(player : Player) -> void:
	pass


func _attack(delta : float, action_pressed : bool, origin : Vector2, direction := Vector2.RIGHT) -> bool:
	return false


func stage_up() -> void:
	stage = min(stage + 1, 3)
