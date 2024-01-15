class_name BulletUtil extends Node


enum BulletType {
	NON_DIRECTIONAL,
	DIRECTIONAL,
	VECTOR
}


const BULLETS := {
	BulletType.NON_DIRECTIONAL: preload("res://addons/godonmaku/bullet.tscn")
}


const BULLET_SPRITES := {
	BulletType.NON_DIRECTIONAL: preload("res://addons/godonmaku/bullet_1.png")
}


const MAX_BULLETS := 10000


@onready var pool : Node2D = $Pool


var bullet_scn : PackedScene
var bullet_index := 0


func _ready() -> void:
	_BulletUtil.kill_bullets()


func _exit_tree() -> void:
	_BulletUtil.kill_bullets()


func get_bullet_scene(bullet_type : BulletType) -> PackedScene:
	return BULLETS.get(bullet_type, BULLETS[BulletType.NON_DIRECTIONAL])


func get_next_bullet(bullet_type : BulletType) -> Bullet:
	if pool.get_child_count() >= MAX_BULLETS:
		bullet_index = (bullet_index + 1) % pool.get_child_count()
		var bullet : Bullet = pool.get_child(bullet_index) as Bullet
		bullet._swap(bullet_type)
		return bullet
	else:
		pool.add_child(get_bullet_scene(bullet_type).instantiate())
		var b = pool.get_child(bullet_index)
		bullet_index += 1
		return b


func reset_bullets() -> void:
	bullet_index = 0


func kill_bullets() -> void:
	reset_bullets()
	for bullet in pool.get_children():
		bullet.queue_free()
