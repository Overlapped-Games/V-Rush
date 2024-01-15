class_name ProjectileWeapon extends Weapon


@onready var projectile_snc = preload("res://assets/player/projectile_basic.tscn")
@onready var pool : Node2D = $Pool


@export var max_projectiles := 20
@export var attack_rate := 0.25


var next_index := 0
var active_projectiles := 0


#func _ready() -> void:
	#while pool.get_child_count() < max_projectiles:
		#var projectile : ProjectileBase = projectile_snc.instantiate()
		#pool.add_child(projectile)


func _start(player : Player) -> void:
	attack_timer.start(attack_rate)
	
	while pool.get_child_count() < max_projectiles:
		var projectile : ProjectileBase = projectile_snc.instantiate()
		pool.add_child(projectile)
		projectile.player_stats = player.stats


func _attack(origin : Vector2, target_pos : Vector2) -> void:
	if active_projectiles == max_projectiles:
		print_rich("[rainbow]Max projectiles active...[/rainbow]")
		return
	
	var next : ProjectileBase = pool.get_child(next_index)
	while next.active:
		next_index = (next_index + 1) % max_projectiles
		next = pool.get_child(next_index)
	#print("projectile[%s]" % [next_index])
	next._fire(origin, target_pos)
	next.expired.connect(_on_projectile_expired)
	active_projectiles += 1
	
	next_index = (next_index + 1) % max_projectiles


func _on_projectile_expired(projectile : ProjectileBase):
	active_projectiles -= 1
	projectile.expired.disconnect(_on_projectile_expired)
