class_name Player extends CharacterBody2D

signal grazed()
signal stats_changed()
signal health_updated(new_health : int)
signal defeated()


const BASE_SPEED := 150.0

@onready var void_bomb : PackedScene = preload("res://assets/skills/void_bomb.tscn")
@onready var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var grazebox : Grazebox = $Grazebox
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var sprite : Sprite2D = $Sprite
@onready var weapon : Weapon = $Weapon
@onready var abilities : Node = $Abilities # meant for use with the cards
@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var invuln_timer : Timer = $InvulnTimer
@onready var graze_fx : CPUParticles2D = $graze_fx


## Health
@export var max_health : int = 50
@export var current_health : int = 50:
	set(value):
		current_health = value
		health_updated.emit(current_health)
## Memory
@export var max_memory : int = 4
## Attack
@export var attack : int = 5
## Defense
@export var defense : int = 0
## Movement speed
@export var speed_modifier : int = 0
## Focus speed multiplier
@export var focus_speed_multiplier : float = 0.375
## Skill gauge fill rate
@export var gauge_fill_rate : float = 1.0

# gain 1 additional memory every 1024 pieces collected
var memory_exp : int = 0 # in kilobytes
var attack_exp : int = 0

var invulnerable : bool = false
var dead : bool = false

var t_fire : float = 0.0
var can_fire : bool = true
var firing : bool = false
var speed_multiplier : float = 1.0

var camera : Cammaku
var screen_extents : Vector2

var skill_queue := []
var bugs := []


func _ready() -> void:
	hurtbox.hit.connect(_on_hit)
	hurtbox.body_entered.connect(_on_hit_body)
	
	grazebox.area_entered.connect(_on_area_entered)
	grazebox.grazed.connect(_on_grazed)
	camera = get_tree().get_first_node_in_group("camera") as Cammaku
	screen_extents = get_viewport_rect().size / (2 * camera.zoom)
	
	show()
	animator.play("floating")
	animator.animation_finished.connect(
		func(anim_name): 
			if anim_name == "invulnerable_flash":
				#print("finished '%s'" % [anim_name])
				set_invulnerable(false)
				animator.play("floating")
				sprite.show()
				show()
	)
	animator.play("invulnerable_flash")
	#damage(10)

func _physics_process(delta : float) -> void:
	if Input.is_action_pressed("focus"):
		speed_multiplier = focus_speed_multiplier
	elif Input.is_action_just_released("focus"):
		speed_multiplier = 1
	
	
	var direction : Vector2 = Input.get_vector("input_left", "input_right", "input_up", "input_down").normalized()
	
	velocity = direction * ((BASE_SPEED * speed_multiplier) + speed_modifier)
	
	# prevent from trying to move diagonally when blocked from the top or bottom
	if (is_on_ceiling() or is_on_floor()) and direction.y != 0:
		velocity.x = roundi(direction.x) * ((BASE_SPEED * speed_multiplier) + speed_modifier)
		
	# prevent from trying to move diagonally when blocked from the sides
	if is_on_wall() and direction.x != 0: 
		velocity.y = roundi(direction.y) * ((BASE_SPEED * speed_multiplier) + speed_modifier)
	
	#print("w=%s, c=%s, f=%s" % [is_on_wall(), is_on_ceiling(), is_on_floor()])
	move_and_slide()
	
	do_attack(delta)


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventAction and not event is InputEventJoypadButton and not event is InputEventJoypadMotion: return
	
	if Input.is_action_just_pressed("skill_menu"):
		#GameManager.open_skill_menu()
		pass
	elif Input.is_action_just_pressed("skill"):
		#if skill_queue.is_empty(): return
		#var a = skill_queue.pop_front()
		#print("skill=", a.name)
		if !GameManager.gauge_ready: return
		GameManager.reset_gauge()
		var v : VoidBomb = void_bomb.instantiate()
		add_child(v)
		v.set_as_top_level(true)
		v.global_position = Vector2(global_position.x + 80, global_position.y)

	
	# debugging
	#var just_pressed = event.is_pressed() and not event.is_echo()
	#if Input.is_key_pressed(KEY_1) and just_pressed:
		#weapon.stage = 1
	#elif Input.is_key_pressed(KEY_2) and just_pressed:
		#weapon.stage = 2
	#elif Input.is_key_pressed(KEY_3) and just_pressed:
		#weapon.stage = 3
	#elif Input.is_key_pressed(KEY_4) and just_pressed:
		#weapon.stage = 4


func do_attack(delta : float) -> void:
	firing = weapon._attack(delta, Input.is_action_pressed("fire"), global_position, Vector2.RIGHT)


func attack_up(value : int) -> void:
	if weapon.stage == weapon.max_stage: return
	var max = 10 if weapon.stage == 1 else 20 if weapon.stage == 2 else 30
	attack_exp = clamp(attack_exp + value, 0, max)
	
	if attack_exp == max:
		weapon.stage_up()
		attack_exp = 0


func set_invulnerable(inv : bool) -> void:
	$Hurtbox/Collider.disabled = inv
	invulnerable = inv


func revive() -> void:
	current_health = max_health
	set_invulnerable(false)
	set_physics_process(true)
	animator.stop()
	animator.play("floating")
	sprite.show()
	show()


func damage(damage : int) -> void:
	if invulnerable: return
	current_health = clampi(current_health - max(damage - defense, 1), 0, max_health)
	if current_health == 0:
		#print("DEAD")
		AudioManager.player_sfx("player_death")
		set_physics_process(false)
		set_invulnerable(true)
		hide()
		defeated.emit()
		return
	
	AudioManager.player_sfx("player_damaged")
	set_invulnerable(true)
	animator.play("invulnerable_flash")


func _on_hit_body(body : Node) -> void:
	damage(10)


func _on_hit(bullet : Bullet) -> void:
	damage(bullet.damage)


func _on_area_entered(area : Area2D) -> void:
	#if area.collision_layer & 0b0100_0000 > 0:
		## collectibles
		#pass
	pass


# TODO: implement collecting power-ups. when change stats, should updat all projectile stats too

func _on_grazed() -> void:
	grazed.emit()
	graze_fx.set_emitting(true)
