class_name ProjectileWeapon extends Weapon


const ENEMY_HITBOX_LAYER := 0b0100

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
		#AudioManager.play("player_fire") # might be too annoying
		can_fire = false
		fire(origin, direction)
		#var next : Bullet = BulletUtil.get_player_bullet()
		#next._fire(Vector2(origin.x + 16, origin.y), direction, BulletUtil.BulletShape.BOX, 800, 0, 1600, {"x": 14, "y": 6})
	
	if stage == 3:
		if !can_fire_3:
			t_fire_3 += delta
			
		if !can_fire_3 and t_fire_3 >= 1:
			t_fire_3 = 0
			can_fire_3 = true
		
		if can_fire_3 and action_pressed:
			can_fire_3 = false
			var frag_one : Bullet = BulletUtil.get_player_bullet(3)
			var frag_two : Bullet = BulletUtil.get_player_bullet(3)
			frag_one._fire(Vector2(origin.x + 4, origin.y - 18), direction, 300, 5, 1600)
			frag_two._fire(Vector2(origin.x + 4, origin.y + 18), direction, 300, 5, 1600)
	
	if can_fire: return true
	
	return false


func fire(origin : Vector2, direction : Vector2) -> void:
	match stage:
		1:
			var next : Bullet = BulletUtil.get_player_bullet(1)
			next._fire(Vector2(origin.x + 16, origin.y), direction, 800, 0, 1600)
		2:
			var one : Bullet = BulletUtil.get_player_bullet(2)
			var two : Bullet = BulletUtil.get_player_bullet(2)
			one._fire(Vector2(origin.x + 16, origin.y - 4), direction, 800, 0, 1600)
			two._fire(Vector2(origin.x + 16, origin.y + 4), direction, 800, 0, 1600)
		3:
			var one : Bullet = BulletUtil.get_player_bullet(2)
			var two : Bullet = BulletUtil.get_player_bullet(2)
			one._fire(Vector2(origin.x + 16, origin.y - 4), direction, 800, 0, 1600)
			two._fire(Vector2(origin.x + 16, origin.y + 4), direction, 800, 0, 1600)


func _on_projectile_expired(projectile : ProjectileBase):
	#active_projectiles -= 1
	projectile.expired.disconnect(_on_projectile_expired)
