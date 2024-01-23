class_name SkewllaxBackground extends Node2D

@export var scroll_rate := 0.125
@export var max_skews := 8

var background : Node2D
var original_position : Vector2

var t := 0.0
var skew_count := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background = get_child(0).duplicate(0b0111)
	original_position = background.global_position
	#set_physics_process(false)


func _physics_process(delta : float) -> void:
	t += scroll_rate / 2
	
	if t >= 1:
		var bg : Node2D = get_child(0) as Node2D
		t = 0
		bg.transform.y.x -= PI / 180
		bg.position.x -= 1
		skew_count += 1
		if skew_count == max_skews:
			skew_count = 0
			#var last = get_child(get_child_count() - 1)
			bg.global_position = original_position
			bg.transform.y.x = max_skews * PI / 180
			
			#var next = background.duplicate(0b0111)
			#add_child(next)
			#next.position = Vector2(bg.position.x + max_skews, bg.position.y)
			#
			##if(get_child_count() == 2):
			#get_child(0).queue_free()
