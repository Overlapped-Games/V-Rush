class_name SkewllaxBackground extends Node2D

@export var scroll_rate := 0.125

var array : Array[Node2D] = []
var background : Node2D
var t := 0.0

var skew_count := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background = get_child(0).duplicate(0b0111)


func _physics_process(delta : float) -> void:
	t += scroll_rate / 2
	
	if t >= 1:
		t = 0
		#for child in get_children():
		var bg : Node2D = get_child(0) as Node2D
		bg.skew += PI / 180
		bg.position.x -= 1
			
		skew_count += 1
		bg.transform.y.y = 1
		if skew_count == 8:
			skew_count = 0
			#var last = get_child(get_child_count() - 1)
			var next = background.duplicate(0b0111)
			add_child(next)
			next.position = Vector2(bg.position.x + 8, bg.position.y)
			
			#if(get_child_count() == 2):
			get_child(0).queue_free()
