class_name Grazebox extends Area2D


signal grazed


func _on_grazed():
	grazed.emit()
