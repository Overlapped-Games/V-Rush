class_name VoidBomb extends Area2D

@export var damage : int = 300
@export var speed : int = 60
@export var duration : int = 4

var t : float = 0.0
var counter : int = 0
var frames : int = 0


func _ready() -> void:
	body_entered.connect(_on_enemy_entered)
	counter = 0
	

func _physics_process(delta : float) -> void:
	t += delta * speed
	
	frames += 1
	if frames == 60:
		counter += 1
		frames = 0
	
	if counter >= duration:
		queue_free()


func _on_hit(bullet : Bullet) -> void:
	bullet._disable() # disable bullets that run into this


func _on_enemy_entered(enemy : Enemy) -> void:
	enemy._hit_by_skill(damage)
