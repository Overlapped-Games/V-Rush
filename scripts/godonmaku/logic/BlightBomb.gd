## Special bullet that explodes into smaller bullets when it is hit by player attacks or other blight bomb sub bullets
class_name BlightBomb extends Bullet


@onready var hitbox : Hurtbox = $Hitbox
@onready var detonation_pattern : Danmaku = $dp


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	hitbox.hit.connect(_on_hit)
	hitbox.area_entered.connect(_on_hit_by_blight)
	show()
	
	if !detonation_pattern:
		detonation_pattern = Danmaku.new()
		add_child(detonation_pattern)
		detonation_pattern.name = "dp"
		detonation_pattern.fixed(Vector2.LEFT, BulletUtil.BulletType.NON_DIRECTIONAL,
			detonation_pattern.fire.bind(
				detonation_pattern.lines.bind(6, 0, 1, 0, 16, 120, 0, 500,
					detonation_pattern.per_bullet.bind(
						func(bullet : Bullet): bullet.hitbox_layer = bullet.hitbox_layer | 0b0100_0000_0000
					)
				)
			)
		)


func detonate() -> void:
	print("kaboom")
	detonation_pattern._start()
	queue_free()


func _on_hit(bullet : Bullet) -> void:
	print("hit by player, explode")
	detonate()


func _on_hit_by_blight(area : Area2D) -> void:
	if area.collision_layer & 0b0100_0000_0000 > 0:
		print("hit by blight")
		detonate()
