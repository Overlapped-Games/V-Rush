## Special bullet that explodes into smaller bullets when it is hit by player attacks or other blight bomb sub bullets
class_name BlightBomb extends Bullet


signal detonated(value : int)


@onready var hitbox : Hurtbox = $Hitbox
@onready var collider : CollisionShape2D = $Hitbox/CollisionShape2D
@onready var detonation_pattern : Danmaku = $dp


@export var score_value := 2000


var a_t := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	detonated.connect(GameManager._on_scorable_hit)
	hitbox.hit.connect(_on_hit)
	hitbox.area_entered.connect(_on_hit_by_blight)
	collider.set_disabled(true)
	#if detonation_pattern:
		#detonation_pattern.per_bullet_f = func(bullet : Bullet): bullet.modulate = Color8(26, 255, 26)
	frame = 14
	#if !detonation_pattern:
		#detonation_pattern = Danmaku.new()
		#add_child(detonation_pattern)
		#detonation_pattern.name = "dp"
		#detonation_pattern.fixed(Vector2.LEFT, BulletUtil.BulletType.NON_DIRECTIONAL,
			#detonation_pattern.fire.bind(
				#detonation_pattern.ring.bind(6, 0, 1, 0, 16, 120, 0, 500,
					#detonation_pattern.per_bullet.bind(func(bullet : Bullet): 
						#bullet.hitbox_layer = bullet.hitbox_layer | 0b0100_0000_0000 # TODO: freezes up when detonating bombs
						#bullet.modulate = Color8(26, 255, 26)
						#)
				#)
			#)
		#)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	a_t += delta * 7.5
	
	if a_t >= 1:
		a_t = 0
		frame = wrapi(frame + 1, 14, 16)
		#frame = (frame - 14 + 1 + 2) % 2 + 14


func _fire(origin : Vector2, target_direction : Vector2, bullet_shape : BulletUtil.BulletShape, vel := 100, accel := 0, max_vel := 1000, shape_properties := {}) -> void:
	super._fire(origin, target_direction, bullet_shape, vel, accel, max_vel, shape_properties)
	collider.set_disabled(false)


func _disable():
	expired.emit(self)
	collider.set_disabled(true)
	hide()
	set_physics_process(false)
	active = false


func detonate() -> void:
	print("kaboom")
	detonated.emit(score_value)
	detonation_pattern._start()
	_disable()


func _on_hit(bullet : Bullet) -> void:
	print("hit by player, explode")
	detonate()


func _on_hit_by_blight(area : Area2D) -> void:
	if area.collision_layer & 0b0100_0000_0000 > 0:
		print("hit by blight")
		detonate()
