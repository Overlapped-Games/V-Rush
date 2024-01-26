extends Node2D


enum BulletType {
	NON_DIRECTIONAL,
	NON_DIRECTIONAL_2,
	NON_DIRECTIONAL_3,
	NON_DIRECTIONAL_4,
	NON_DIRECTIONAL_MEDIUM,
	NON_DIRECTIONAL_MEDIUM_4,
	DIRECTIONAL,
	VECTOR,
	BLIGHT_BOMB,
	FRAG_1,
	PLAYER,
	PLAYER_FRAG
}

enum BulletShape {
	CIRCLE,
	BOX
}


# TODO: if making an actual plugin, make load bullets from a folder or something
const BULLETS := {
	BulletType.NON_DIRECTIONAL: preload("res://assets/bullets/bullet.tscn"),
	BulletType.NON_DIRECTIONAL_2: preload("res://assets/bullets/bullet_2.tscn"),
	BulletType.NON_DIRECTIONAL_3: preload("res://assets/bullets/bullet_3.tscn"),
	BulletType.NON_DIRECTIONAL_4: preload("res://assets/bullets/bullet_4.tscn"),
	BulletType.NON_DIRECTIONAL_MEDIUM: preload("res://assets/bullets/bullet_medium.tscn"),
	BulletType.NON_DIRECTIONAL_MEDIUM_4: preload("res://assets/bullets/bullet_medium_4.tscn"),
	BulletType.BLIGHT_BOMB: preload("res://assets/bullets/blight_bomb.tscn"),
	BulletType.FRAG_1: preload("res://assets/bullets/frag_bullet.tscn"),
	BulletType.PLAYER_FRAG: preload("res://assets/player/player_bullet_3_frag.tscn")
}

const BULLET_SPRITES := {
	BulletType.NON_DIRECTIONAL: preload("res://assets/art/bullet_1.png")
}

const PLAYER_BULLET := preload("res://assets/player/player_bullet.tscn")

const PLAYER_BULLETS := {
	1: preload("res://assets/player/player_bullet.tscn"),
	2: preload("res://assets/player/player_bullet.tscn"),
	3: preload("res://assets/player/player_bullet_3.tscn"),
	4: preload("res://assets/player/player_bullet.tscn")
}

const PLAYER_BULLET_TYPES := {
	1: BulletType.PLAYER,
	2: BulletType.PLAYER,
	3: BulletType.PLAYER_FRAG,
}

const MAX_ENEMY_BULLETS := 10000
const MAX_PLAYER_BULLETS := 1000


@onready var direct_space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

var enemy_pool : Node2D
var player_pool : Node2D


var bullet_scn : PackedScene
var bullet_index := 0
var player_bullet_index := 0

var active_enemy_bullets : Array[Bullet] = []


func _ready() -> void:
	#var world : Node2D = get_tree().get_first_node_in_group("world")
	enemy_pool = Node2D.new()
	player_pool = Node2D.new()
	add_child(enemy_pool)
	add_child(player_pool)
	enemy_pool.name = "EnemyPool"
	player_pool.name = "PlayerPool"
	#direct_space_state = get_world_2d().direct_space_state
	kill_bullets()



func _exit_tree() -> void:
	reparent(get_tree().root)
	kill_bullets()


func get_bullet_shape(bullet_shape : BulletShape, properties : Dictionary) -> Shape2D:
	if bullet_shape == BulletShape.CIRCLE:
		var circle = CircleShape2D.new()
		circle.radius = properties["radius"]
		return circle
	else:
		var box = RectangleShape2D.new()
		box.size.x = properties["x"]
		box.size.y = properties["y"]
		return box


func get_bullet_scene(bullet_type : BulletUtil.BulletType) -> PackedScene:
	return BULLETS.get(bullet_type, BULLETS[BulletType.NON_DIRECTIONAL])


func get_next_bullet(bullet_type : BulletUtil.BulletType) -> Bullet:
	if enemy_pool.get_child_count() >= MAX_ENEMY_BULLETS:
		bullet_index = (bullet_index + 1) % enemy_pool.get_child_count()
		var bullet : Bullet = enemy_pool.get_child(bullet_index) as Bullet
		if bullet.bullet_type != bullet_type:
			var new = get_bullet_scene(bullet_type).instantiate()
			enemy_pool.add_child(new)
			#bullet = get_bullet_scene(bullet_type).instantiate()
			bullet.queue_free()
			bullet = new
		active_enemy_bullets.append(bullet)
		return bullet
	else:
		# if not enough bullets, add more
		while bullet_index >= enemy_pool.get_child_count():
			enemy_pool.add_child(get_bullet_scene(bullet_type).instantiate())
		var b = enemy_pool.get_child(bullet_index)
		bullet_index += 1
		active_enemy_bullets.append(b)
		return b


func intersect_shape(query : PhysicsShapeQueryParameters2D, max_results := 32) -> Array[Dictionary]:
	return direct_space_state.intersect_shape(query, max_results)


func get_player_bullet(stage : int = 1) -> Bullet:
	if player_pool.get_child_count() >= MAX_PLAYER_BULLETS:
		player_bullet_index = (player_bullet_index + 1) % player_pool.get_child_count()
		var bullet : Bullet = player_pool.get_child(player_bullet_index) as Bullet
		if bullet.bullet_type != PLAYER_BULLET_TYPES[stage]:
			var new = PLAYER_BULLETS[stage].instantiate()
			player_pool.add_child(new)
			bullet.queue_free()
			bullet = new
		return bullet
	else:
		player_pool.add_child(PLAYER_BULLETS.get(stage, 1).instantiate())
		var b = player_pool.get_child(player_bullet_index)
		player_bullet_index += 1
		return b


func consume_bullets() -> void:
	pass # TODO: when a boss's phase gets cleared, need to disable all active bullets, turn them into points, etc


func reset_bullets() -> void:
	active_enemy_bullets.clear()
	bullet_index = 0
	player_bullet_index = 0


func kill_bullets() -> void:
	reset_bullets()
	
	for bullet in enemy_pool.get_children():
		bullet.queue_free()
		
	for bullet in player_pool.get_children():
		bullet.queue_free()
		
