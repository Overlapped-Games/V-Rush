class_name EnemyContainer extends Node2D



func _start() -> void:
	# start any enemy child nodes
	for child in get_children().filter(func(child): return child is Enemy):
		child._start()
