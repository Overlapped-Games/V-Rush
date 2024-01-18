class_name ProjectileWeapon extends Weapon


const ENEMY_HITBOX_LAYER := 0b0100


@export var attack_rate := 10

var active_projectiles := 0
var t_fire := 0.0
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


func _attack(delta : float, action_pressed : bool, origin : Vector2, direction := Vector2.RIGHT) -> bool:
	if !can_fire:
		t_fire += attack_rate * delta
	
	if !can_fire and t_fire >= 1:
		t_fire = 0
		can_fire = true
	
	if can_fire and action_pressed:
		can_fire = false
		var next : Bullet = BulletUtil.get_player_bullet()
		next._fire(Vector2(global_position.x + 16, global_position.y), direction, BulletUtil.BulletShape.BOX, 800, 0, 1600, {"x": 14, "y": 6})
		return true
	return false
	


func _on_projectile_expired(projectile : ProjectileBase):
	active_projectiles -= 1
	projectile.expired.disconnect(_on_projectile_expired)
