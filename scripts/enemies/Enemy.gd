class_name Enemy extends RigidBody2D


signal expired(enemy : Enemy)


@onready var hurtbox : Area2D = $Hurtbox
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite

@onready var ph_delta : float = get_physics_process_delta_time()

## Health
@export var max_health : int = 50
@export var current_health : int = 50
## Defense
@export var defense : int = 0


var hit_cooldown : float = 10
var invulnerable : bool = false
var t : float = 0.0

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#hurtbox.area_entered.connect(_on_hit_by_player)


func _physics_process(delta) -> void:
	if !invulnerable: return
	t += hit_cooldown * delta
	if t >= 1:
		t = 0
		print("can be hit")
		set_invulnerable(false)


func set_invulnerable(inv : bool) -> void:
	$Hurtbox/Collider.disabled = inv
	invulnerable = inv
	print_debug("invuln=", inv)


func _on_hit(bullet : Bullet) -> void:
	# TODO: handle damaging player here; check if area is an enemy attack or a hazard
	print("%s hit for %s..." % [name, bullet.damage])
	if invulnerable: return
	current_health = clampi(current_health - max(bullet.damage - defense, 1), 0, max_health)
	if current_health == 0:
		print("DEAD")
		set_physics_process(false)
		expired.emit(self)
		queue_free()
		return
		
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate:v", 1, hit_cooldown * ph_delta / 2).from(15)
	set_invulnerable(true)


func _on_projectile_collide(projectile : ProjectileBase, damage : int) -> void:
	#print("hit by player for %s damage" % [damage])
	pass

