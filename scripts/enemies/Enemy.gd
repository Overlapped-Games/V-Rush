class_name Enemy extends RigidBody2D


@onready var hurtbox : Area2D = $Hurtbox
@onready var animator : AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.area_entered.connect(_on_hit_by_player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func _on_hit_by_player(area : Area2D) -> void:
	# TODO: handle damaging enemy here
	print("hit by player attack")


func _on_projectile_collide(projectile : ProjectileBase, damage : int) -> void:
	#print("hit by player for %s damage" % [damage])
	pass

