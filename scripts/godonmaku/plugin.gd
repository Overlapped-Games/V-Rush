@tool
extends EditorPlugin


#const GRAPH = preload("res://addons/godonmaku/graph/graph_editor.tscn")
#
#var graph_instance : GraphEditor
#
#
#func _init():
	#name = "Godonmaku "
#
#
#func _enter_tree() -> void:
	#print_debug("_enter_tree")
	#
	#graph_instance = GRAPH.instantiate()
	#graph_instance.hide()
	#get_editor_interface().get_editor_main_screen().add_child(graph_instance)
	#_make_visible(false)
#
#
#func _exit_tree() -> void:
	#_make_visible(false)
	#remove_control_from_bottom_panel(graph_instance)
	#graph_instance.queue_free()
#
#
#func _enable_plugin():
	#print("_enable_plugin")
	#print("before - %s" % [get_tree().root.get_children()])
	##add_autoload_singleton("Godonmaku", "res://addons/chicken_scratch/core/DialogueManager.gd")
	#print("after  - %s" % [get_tree().root.get_children()])
	##default_settings()
	#graph_instance.on_plugin_start()
#
#
#func _has_main_screen():
	#return true
#
#
#func _make_visible(visible):
	#if(graph_instance):
		#graph_instance.visible = visible
#
#
#func _get_plugin_name():
	#return "Godonmaku"
#
#
#func _get_plugin_icon():
	#return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")
