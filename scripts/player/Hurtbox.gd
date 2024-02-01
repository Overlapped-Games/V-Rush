class_name Hurtbox extends Area2D


signal hit(bullet : Node2D)


func _on_hit(bullet : Node2D):
	hit.emit(bullet)
