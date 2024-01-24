class_name Enemy extends RigidBody2D


signal expired(enemy : Enemy) # moved off screen
signal hit
signal defeated(enemy : Enemy) # ded


@onready var hurtbox : Area2D = $Hurtbox
@onready var collider : CollisionShape2D = $Hurtbox/Collider
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite
@onready var health_bar : TextureProgressBar = $HealthBar

@onready var ph_delta : float = get_physics_process_delta_time()

## Health
@export var max_health : int = 50
@export var current_health : int = 50
@export var invlunerability_time : float = 10
## Defense
@export var defense : int = 0
@export var defeat_value : int = 1000


var invulnerable : bool = false
var t : float = 0.0


func _ready() -> void:
	set_physics_process(false)
	set_invulnerable(true)
	collider.set_disabled(true)
	if !health_bar:
		health_bar = load("res://assets/enemies/enemy_health_bar.tscn").instantiate()
		health_bar.name = "HealthBar"
	health_bar.hide()
	t = 0
	defeated.connect(GameManager._on_enemy_defeated)
	hit.connect(GameManager._on_enemy_hit)
	current_health = max_health


func _physics_process(delta : float) -> void:
	if invulnerable:
		t += invlunerability_time * delta
		
		if t >= 1:
			t = 0
			print("can be hit")
			set_invulnerable(false)
	else:
		t = 0


func _move(delta : float) -> void:
	pass


func _start() -> void:
	set_physics_process(true)
	set_invulnerable(false)
	collider.set_disabled(false)


func set_invulnerable(inv : bool) -> void:
	$Hurtbox/Collider.disabled = inv
	invulnerable = inv
	print_debug("invuln=", inv)


func _on_hit(bullet : Bullet) -> void:
	print("%s hit for %s..." % [name, bullet.damage])
	if invulnerable: return
	if invlunerability_time > 0:
		set_invulnerable(true)
	current_health = clampi(current_health - max(bullet.damage - defense, 1), 0, max_health)
	var tween : Tween = create_tween()
	tween.tween_property(sprite, "modulate:v", 1, 5 * ph_delta).from(15)
	if current_health > 0:
		health_bar.show()
		health_bar.value = 100.0 * current_health / max_health 
	
	if current_health == 0:
		print("DEAD")
		set_physics_process(false)
		defeated.emit(self)
		queue_free()
		return
	
	hit.emit(self)


func _on_projectile_collide(projectile : ProjectileBase, damage : int) -> void:
	#print("hit by player for %s damage" % [damage])
	pass


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	
	var children: Array[Node] = get_children()

	if !children.any(func(x): return x is TextureProgressBar and x.name == "HealthBar"):
		warnings.append("Enemy is missing a healthbar.")
	

	return warnings
