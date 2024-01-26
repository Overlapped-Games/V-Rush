class_name PlayerFragBullet extends AnimatedBullet


@onready var detonation_pattern : Danmaku = $Danmaku


func _handle_collision(delta : float) -> void:
	query.collision_mask = hitbox_layer
	query.transform = global_transform
	
	var hit : Array[Dictionary] = BulletUtil.intersect_shape(query, 1)
	if hit:
		var coll : Node2D = hit[0]["collider"]
		
		#print("rest_info=%s" % [BulletUtil.direct_space_state.get_rest_info(query)])
		if coll.has_method("_on_hit"):
			coll._on_hit(self)
		detonate(coll)
	else:
		if type == Type.ENEMY:
			query.collision_mask = grazebox_layer
			hit = BulletUtil.intersect_shape(query, 1)
			if hit and can_graze:
				can_graze = false
				var coll = hit[0]["collider"]
				coll._on_grazed()


func _disable():
	expired.emit(self)
	hide()
	set_physics_process(false)
	active = false


func detonate(coll : Node) -> void:
	_disable()
	if coll.is_in_group("camera_boundary"): return
	detonation_pattern._start()
