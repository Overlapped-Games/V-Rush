extends Node2D


enum BulletType {
	NON_DIRECTIONAL,
	NON_DIRECTIONAL_MEDIUM,
	DIRECTIONAL,
	VECTOR,
	BLIGHT_BOMB
}

enum BulletShape {
	CIRCLE,
	BOX
}


# TODO: if making an actual plugin, make load bullets from a folder or something
const BULLETS := {
	BulletType.NON_DIRECTIONAL: preload("res://assets/bullets/bullet.tscn"),
	BulletType.NON_DIRECTIONAL_MEDIUM: preload("res://assets/bullets/bullet_medium.tscn"),
	BulletType.BLIGHT_BOMB: preload("res://assets/bullets/blight_bomb.tscn")
}

const BULLET_SPRITES := {
	BulletType.NON_DIRECTIONAL: preload("res://assets/art/bullet_1.png")
}

const PLAYER_BULLETS := preload("res://assets/player/player_bullet.tscn")

const MAX_ENEMY_BULLETS := 10000
const MAX_PLAYER_BULLETS := 1000


#@onready var enemy_pool : Node2D = $EnemyPool
#@onready var player_pool : Node2D = $PlayerPool

var enemy_pool : Node2D
var player_pool : Node2D
@onready var direct_space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state


var bullet_scn : PackedScene
var bullet_index := 0
var player_bullet_index := 0


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
		bullet._swap(bullet_type)
		return bullet
	else:
		enemy_pool.add_child(get_bullet_scene(bullet_type).instantiate())
		bullet_index += 1
		
		while bullet_index >= enemy_pool.get_child_count():
			enemy_pool.add_child(get_bullet_scene(bullet_type).instantiate())
		print("[%s]c=%s, %s" % [bullet_index, enemy_pool.get_child_count(), BulletUtil.BulletType.keys()[bullet_type]])
		var b = enemy_pool.get_child(bullet_index - 1)
		print("enemy_pool.get_child(%s - 1)=%s" % [bullet_index, enemy_pool.get_child(bullet_index - 1)])
		#var b = enemy_pool.get_child(bullet_index)
		#bullet_index += 1
		return b


func intersect_shape(query : PhysicsShapeQueryParameters2D, max_results := 32) -> Array[Dictionary]:
	return direct_space_state.intersect_shape(query, max_results)


func get_player_bullet() -> Bullet:
	if player_pool.get_child_count() >= MAX_PLAYER_BULLETS:
		player_bullet_index = (player_bullet_index + 1) % player_pool.get_child_count()
		var bullet : Bullet = player_pool.get_child(player_bullet_index) as Bullet
		#bullet._swap(bullet_type)
		return bullet
	else:
		player_pool.add_child(PLAYER_BULLETS.instantiate())
		var b = player_pool.get_child(player_bullet_index)
		player_bullet_index += 1
		return b


func reset_bullets() -> void:
	bullet_index = 0
	player_bullet_index = 0


func kill_bullets() -> void:
	reset_bullets()
	
	for bullet in enemy_pool.get_children():
		bullet.queue_free()
		
	for bullet in player_pool.get_children():
		bullet.queue_free()
		
