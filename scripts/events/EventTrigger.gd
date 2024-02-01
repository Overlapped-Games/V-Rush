@tool
class_name EventTrigger extends Area2D

#@onready var level_background = $"../Stage/SkewllaxBackground/LevelBackground"
@onready var collider : CollisionShape2D = $CollisionShape2D
signal next_level

func _ready() -> void:
	collision_layer = 0b0010_0000_0000_0000
	collision_mask = 0b0001_0000_0000_0000
	area_entered.connect(_on_camera_entered)


func _on_camera_entered(area : Area2D) -> void:
	# Trigger any event children attached to this node
	for child in get_children():
		if not child is Event: continue
		child._trigger()
		
	#$CollisionShape2D.disabled = true
	#GameManager.set_level(GameManager.get_level() + 1)
	#level_background.set_target_color(GameManager.level_colors[GameManager.get_level() - 1])
	#level_background.change_color(1)
	#$AudioStreamPlayer2D.play()
	#next_level.emit()
