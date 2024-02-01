class_name VectorBullet extends Bullet


func move_curve(delta : float) -> void:
	if !camera: 
		_disable()
		return
		
	velocity = clamp(velocity + acceleration, 0, max_velocity)
	c_t += delta * curve_angle
	var dir : Vector2 = direction.from_angle(direction.angle() + (c_t * PI / 180))
	var distance : float = velocity * delta
	var motion : Vector2 = dir * distance
	
	look_at(global_position + motion)
	global_position += motion
	current_distance += distance
	
	if global_position.y <= -(camera.global_position + screen_extents).y or global_position.y >= (camera.global_position + screen_extents).y or global_position.x <= -(camera.global_position + screen_extents).x or global_position.x >= (camera.global_position + screen_extents).x:
		if max_bounces > 0 and current_bounces < max_bounces:
			if global_position.y <= -(camera.global_position + screen_extents).y or global_position.y >= (camera.global_position + screen_extents).y:
				direction = Vector2(dir.x, -dir.y)
			elif global_position.x <= -(camera.global_position + screen_extents).x or global_position.x >= (camera.global_position + screen_extents).x:
				direction = Vector2(-dir.x, dir.y)
			current_bounces += 1
		else:
			_disable()
		return
