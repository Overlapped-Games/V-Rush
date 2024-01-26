class_name AttackUp extends Collectible

@onready var sprite : Sprite2D = $Sprite2D

@export var value : int = 1


func _ready() -> void:
	super._ready()
	body_entered.connect(_on_player_entered)


func _on_player_entered(player : Node2D) -> void:
	AudioManager.player_sfx("collect")
	player.attack_up(value)
	sprite.hide()
	collider.set_disabled(true)
	var fx : Node2D = GameManager.collect_fx_small.instantiate()
	add_child(fx)
	fx.find_child("AnimationPlayer").animation_finished.connect(func(name): queue_free())
