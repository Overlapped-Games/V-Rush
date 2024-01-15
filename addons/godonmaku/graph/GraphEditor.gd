@tool
class_name GraphEditor extends VBoxContainer


@onready var bullet_node : PackedScene = preload("res://addons/godonmaku/graph/bullet_node_edit.tscn")

@onready var main_graph : MainGraph = $MainGraph


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_plugin_start() -> void:
	pass
