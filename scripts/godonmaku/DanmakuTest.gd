class_name DanmakuTest extends Node2D


@onready var danmaku : PackedScene = preload("res://scripts/godonmaku/danmaku.tscn")

@onready var enemy_scn : PackedScene = preload("res://assets/enemies/base_enemy.tscn")

var d : Danmaku
var e : Danmaku
var c_gen : Danmaku

var d_e : Enemy
var e_e : Enemy

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var b : Danmaku.Builder = Danmaku.Builder.new(Danmaku.BulletType.CIRCLE)
	#add_child(b)
	#var d = b.from_origin(bullet_scn, b.repeat.bind(0.08, b.do_fire.bind(func(bullet : Bullet): print("firing - %s" % [bullet])))).build()
	#d = Danmaku.new()
	player = get_tree().get_first_node_in_group("player")


#func _physics_process(delta: float) -> void:
	#print("FPS:", Engine.get_frames_per_second())


func _input(event: InputEvent) -> void:
	if event is InputEventAction or event is InputEventKey or event is InputEventMouseButton:
		var just_pressed = event.is_pressed() and not event.is_echo()
		if Input.is_key_pressed(KEY_C) and just_pressed:
			if !c_gen:
				c_gen = danmaku.instantiate()
				add_child(c_gen)
			if !c_gen.active:
				c_gen.move_f = c_gen.circle_move.bind(50, 128)
				c_gen.fixed(Vector2(-1, 0), BulletUtil.BulletType.NON_DIRECTIONAL, 
					c_gen.delay.bind(1.4, 16,
						c_gen.repeat.bind(20, 0,
							c_gen.fire.bind(
								c_gen.lines.bind(6, 0, 1, 0, 1, 50, 0, 500
								)
							)
						)
					)
				)
				c_gen._start()
		if Input.is_action_just_pressed("right_click"):
			if !e:
				e_e = enemy_scn.instantiate()
				add_child(e_e)
				e_e.expired.connect(func(enemy): e_e = null)
				e = danmaku.instantiate() as Danmaku
				e_e.add_child(e)
			if !e.active:
				e_e.global_position = get_global_mouse_position()
				#e.chase(GodonmakuUtil.BulletType.NON_DIRECTIONAL, 
					#e.repeat.bind(1, 0,
						#e.fire.bind(
							#e.lines.bind(16, 4, 5, 32, 50, 0, 500,
								#e.stack.bind(4, 0.3)
							#)
						#)
					#)
				#)
				e.fixed(Vector2(-1, 0), BulletUtil.BulletType.NON_DIRECTIONAL, 
					e.repeat.bind(32, 128,
						e.fire.bind(
							e.lines.bind(2, 0, 2, 30, 1, 30, 0, 500,
								e.spin.bind(-0.125,
									e.stack.bind(3, 0.3)
								)
							)
						)
					)
				)
				e._start()
		elif Input.is_action_just_pressed("left_click"):
			if !d:
				d_e = enemy_scn.instantiate()
				add_child(d_e)
				d_e.expired.connect(func(enemy): d_e = null)
				d = danmaku.instantiate()
				d_e.add_child(d)
				
			if !d.active:
				d_e.global_position = get_global_mouse_position()
				#d.from_origin(bullet_scn, 
					#d.repeat.bind(8, 1,
						#d.fire.bind(
							#d.fan_out.bind(1, 6, 4, 7, 0.3, 0.0, get_global_mouse_position(), 30, 0, 500)
						#)
					#)
				#)
				#d.from_origin(bullet_scn, 
					#d.repeat.bind(8, 20,
						#d.fire.bind(
							#d.lines.bind(15, 1, 20, 48, get_global_mouse_position(), 80, 0, 500,
								#d.spin.bind(false, 0.25
									##d.stack.bind(4, 0.3)
								#)
							#)
						#)
					#)
				#)
				#d.fixed(Vector2(-1, 0), BulletUtil.BulletType.NON_DIRECTIONAL, 
					#d.repeat.bind(8, 6,
						#d.fire.bind(
							#d.lines.bind(16, 180, 2, 5, 48, 100, 0, 500
							#)
						#)
					#)
				#)
				d.fixed(Vector2(-1, 0), BulletUtil.BulletType.NON_DIRECTIONAL, 
					d.repeat.bind(16, 64,
						d.fire.bind(
							d.lines.bind(16, 0, 1, 5, 48, 100, 0, 500,
								d.random_angle.bind(-5, 20,
									d.spin.bind(0.125,
										d.bounce.bind(1)
										#d.stack.bind(4, 0.3)
									)
								)
							)
						)
					)
				)
				d._start()
				#await get_tree().create_timer(.7).timeout
				#d.fixed(Vector2(-1, 0), GodonmakuUtil.BulletType.NON_DIRECTIONAL, 
					#d.repeat.bind(8, 6,
						#d.fire.bind(
							#d.lines.bind(16, 1, 0, 32, 150, 0, 500,
								#d.spin.bind(-0.25
										###d.stack.bind(4, 0.3)
								#)
							#)
						#)
					#)
				#)
				#d._start()
		elif Input.is_action_just_pressed("ui_focus_next"):
			if !d:
				d_e = enemy_scn.instantiate()
				add_child(d_e)
				d_e.expired.connect(func(enemy): d_e = null)
				d = danmaku.instantiate()
				d_e.add_child(d)
				
				#d.from_origin(bullet_scn, 
					#d.repeat.bind(8, 1,
						#d.fire.bind(
							#d.fan_out.bind(1, 6, 4, 7, 0.3, 0.0, get_global_mouse_position(), 30, 0, 500)
						#)
					#)
				#)
				#d.from_origin(bullet_scn, 
					#d.repeat.bind(8, 20,
						#d.fire.bind(
							#d.lines.bind(15, 1, 20, 48, get_global_mouse_position(), 80, 0, 500,
								#d.spin.bind(false, 0.25
									##d.stack.bind(4, 0.3)
								#)
							#)
						#)
					#)
				#)
			d.chase(BulletUtil.BulletType.NON_DIRECTIONAL, 
				d.fire.bind(
					d.lines.bind(1, 0, 7, 5, 0, 70, 0, 500,
						d.stack.bind(4, 0.3,
							d.bounce.bind(2)
						)
					)
				)
			)
			#print(d.get_children())
			d._start()
			
			if !e:
				e_e = enemy_scn.instantiate()
				add_child(e_e)
				e_e.expired.connect(func(enemy): e_e = null)
				e = danmaku.instantiate() as Danmaku
				e_e.add_child(e)
				
			e.chase(BulletUtil.BulletType.NON_DIRECTIONAL_MEDIUM, 
				e.fire.bind(
					e.lines.bind(1, 0, 4, 10, 0, 80, 0, 500,
						e.stack.bind(4, 0.3)
					)
				)
			)
			e._start()
		elif Input.is_action_just_pressed("ui_cancel"):
			if d_e:
				d._kill()
			if e_e:
				e._kill()
			if c_gen and c_gen.active:
				c_gen._kill()
			player.revive()
			BulletUtil.kill_bullets()
