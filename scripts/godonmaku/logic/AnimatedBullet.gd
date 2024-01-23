class_name AnimatedBullet extends Bullet

@export var ani_speed : float = 15.0

# inclusive
@export var frame_start : int = 0
# exclusive
@export var frame_end : int = 0

var a_t : float = 0.0


func _ready() -> void:
	super._ready()
	frame = frame_start


func _physics_process(delta : float) -> void:
	super._physics_process(delta)
	
	a_t += delta * 15.0
	
	if a_t >= 1:
		a_t = 0
		frame = (frame - frame_start + 1 + (frame_end - frame_start)) % (frame_end - frame_start) + frame_start
