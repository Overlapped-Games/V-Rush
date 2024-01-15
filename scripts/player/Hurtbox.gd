class_name Hurtbox extends Area2D


signal hit(bullet : Bullet)


func _on_hit(bullet : Bullet):
	hit.emit(bullet)
