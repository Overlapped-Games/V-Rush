class_name ProjectileWeapon extends Weapon


const ENEMY_HITBOX_LAYER := 0b0100


@export var max_projectiles := 200
@export var attack_rate := 10

var active_projectiles := 0
var t := 0.0
var can_fire := true

#func _ready() -> void:
	#while pool.get_child_count() < max_projectiles:
		#var projectile : ProjectileBase = projectile_snc.instantiate()
		#pool.add_child(projectile)



func _start(player : Player) -> void:
	pass
	#attack_timer.start(attack_rate)
	
	#while pool.get_child_count() < max_projectiles:
		#var projectile : ProjectileBase = BulletUtil.get_player_bullet()
		#pool.add_child(projectile)
		#projectile.player_stats = player.stats


func _attack(delta : float, origin : Vector2, direction := Vector2.RIGHT) -> void:
	var next : Bullet = BulletUtil.get_player_bullet()
	next._fire(Vector2(global_position.x + 16, global_position.y), direction, BulletUtil.BulletShape.BOX, 800, 0, 1600, {"x": 14, "y": 6})
	#if active_projectiles == max_projectiles:
		#print_rich("[rainbow]Max projectiles active...[/rainbow]")
		#return
	#
	#t += attack_rate * delta
	#
	#if !can_fire and t >= 1:
		#t = 0
		#can_fire = true
	#
	#if can_fire:
		#var next : Bullet = BulletUtil.get_player_bullet()
		#next._fire(Vector2(global_position.x + 16, global_position.y), direction, BulletUtil.BulletShape.BOX, 800, 0, 1600, {"x": 14, "y": 6})
		#
		#can_fire = false
	
	
	
	#next.expired.connect(_on_projectile_expired)
	#active_projectiles += 1
	#print("projectile[%s]" % [next_index])
	#next._fire(Vector2(origin.x + 16, origin.y), target_pos)
	
	
	#var angle = Vector2.RIGHT.angle()
	#var dir = pattern_origin.from_angle(angle + (i * spread_rad)) # use for multi-bullet spread
	#print("%s, %s,%s" % [pattern_origin, origin, pattern_origin + origin.from_angle(angle) * origin_offset])
	


func _on_projectile_expired(projectile : ProjectileBase):
	active_projectiles -= 1
	projectile.expired.disconnect(_on_projectile_expired)
