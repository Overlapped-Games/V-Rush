class_name GaugeUp extends Collectible

@onready var sprite : Sprite2D = $Sprite2D


func _ready() -> void:
	super._ready()
	body_entered.connect(_on_player_entered)
	modulate.s = 0.75


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	modulate.h = wrapf(modulate.h + (delta / 2), 0, 1)


func _on_player_entered(player : Node2D) -> void:
	AudioManager.player_sfx("collect")
	set_physics_process(false)
	modulate.s = 0
	modulate.h = 0
	GameManager.fill_gauge(10)
	sprite.hide()
	collider.set_disabled(true)
	var fx : Node2D = GameManager.collect_fx.instantiate()
	add_child(fx)
	fx.find_child("AnimationPlayer").animation_finished.connect(func(name): queue_free())
