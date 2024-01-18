class_name Weapon extends Node2D


@onready var attack_timer : Timer = $AttackTimer


func _start(player : Player) -> void:
	pass


func _attack(delta : float, action_pressed : bool, origin : Vector2, direction := Vector2.RIGHT) -> bool:
	return false
