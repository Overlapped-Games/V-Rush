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


func _ready() -> void:
	set_physics_process(true)
	set_invulnerable(false)
	t = 0


func _physics_process(delta : float) -> void:
	if invulnerable:
		t += hit_cooldown * delta
		
		if t >= 1:
			t = 0
			print("can be hit")
			set_invulnerable(false)
	else:
		t = 0


func _move(delta : float) -> void:
	pass


func set_invulnerable(inv : bool) -> void:
	$Hurtbox/Collider.disabled = inv
	invulnerable = inv
	print_debug("invuln=", inv)


func _on_hit(bullet : Bullet) -> void:
	print("%s hit for %s..." % [name, bullet.damage])
	if invulnerable: return
	set_invulnerable(true)
	current_health = clampi(current_health - max(bullet.damage - defense, 1), 0, max_health)
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate:v", 1, hit_cooldown * ph_delta / 2).from(15)
	
	if current_health == 0:
		print("DEAD")
		set_physics_process(false)
		expired.emit(self)
		queue_free()
		return


func _on_projectile_collide(projectile : ProjectileBase, damage : int) -> void:
	#print("hit by player for %s damage" % [damage])
	pass

