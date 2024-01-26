class_name StopAutoScroll extends Event


func _ready() -> void:
	pass
 

func _trigger() -> void:
	get_tree().get_first_node_in_group("scroller")._stop()
	pass
