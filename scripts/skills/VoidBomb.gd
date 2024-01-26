class_name VoidBomb extends Area2D

@onready var animator : AnimationPlayer = $AnimationPlayer

@export var damage : int = 300
@export var speed : int = 100
@export var duration : int = 4

var t : float = 0.0
var counter : int = 0
var frames : int = 0


var camera : Camera2D
var screen_extents : Vector2


func _ready() -> void:
	camera = get_tree().get_first_node_in_group("camera")
	screen_extents = get_viewport_rect().size / (2 * camera.zoom)
	screen_extents += Vector2(80, 80)
	body_entered.connect(_on_enemy_entered)
	counter = 0
	

func _physics_process(delta : float) -> void:
	t += delta * speed
	
	global_position += Vector2.RIGHT * delta * speed
	
	frames += 1
	if frames == 60:
		counter += 1
		frames = 0
	
	if counter >= duration or !camera:
		queue_free()
		return
	
	if global_position.y <= -(camera.global_position + screen_extents).y or global_position.y >= (camera.global_position + screen_extents).y or global_position.x <= -(camera.global_position + screen_extents).x or global_position.x >= (camera.global_position + screen_extents).x:
		queue_free()


func _on_hit(bullet : Bullet) -> void:
	bullet._disable() # disable bullets that run into this


func _on_enemy_entered(enemy : Enemy) -> void:
	enemy._hit_by_skill(damage)
