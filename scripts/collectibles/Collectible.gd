class_name Collectible extends Area2D

@onready var collider : CollisionShape2D = $CollisionShape2D

var camera : Camera2D
var screen_extents : Vector2


func _ready() -> void:
	camera = get_tree().get_first_node_in_group("camera")
	screen_extents = get_viewport_rect().size / (2 * camera.zoom)
	screen_extents += Vector2(16, 16)


func _physics_process(delta: float) -> void:
	if !camera: 
		queue_free()
		return
	
	if global_position.y <= -(camera.global_position + screen_extents).y or global_position.y >= (camera.global_position + screen_extents).y or global_position.x <= -(camera.global_position + screen_extents).x or global_position.x >= (camera.global_position + screen_extents).x:
		queue_free()


#func collect(player : Player) -> void:
	#pass


func _on_player_entered(player : Node2D) -> void:
	pass
