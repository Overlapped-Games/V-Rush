class_name Player extends CharacterBody2D


signal stats_changed()


const BASE_SPEED := 150.0


@onready var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var grazebox : Grazebox = $Grazebox
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var sprite : Sprite2D = $Sprite
@onready var weapon : Weapon = $Weapon
@onready var abilities : Node = $Abilities # meant for use with the cards
@onready var animator : AnimationPlayer = $AnimationPlayer


## Health
@export var max_health : int = 50
@export var current_health : int = 50
## Attack
@export var attack : int = 5
## Defense
@export var defense : int = 0
## Movement speed
@export var speed_modifier : int = 0
## Focus speed multiplier
@export var focus_speed_multiplier : float = 0.375
## Ability gauge fill rate
@export var gauge_fill_rate : float = 1.0

var dead := false
var can_fire : bool = true
var firing : bool = false
var speed_multiplier : float = 1.0

var camera : Cammaku
var screen_extents : Vector2

var ability_queue := []
var bugs := []


func _ready() -> void:
	hurtbox.hit.connect(_on_hit)
	grazebox.grazed.connect(_on_grazed)
	camera = get_tree().get_first_node_in_group("camera") as Cammaku
	screen_extents = get_viewport_rect().size / (2 * camera.zoom)


func _physics_process(delta : float) -> void:
	if Input.is_action_pressed("focus"):
		speed_multiplier = focus_speed_multiplier
	elif Input.is_action_just_released("focus"):
		speed_multiplier = 1
		
	
	var direction : Vector2 = Input.get_vector("input_left", "input_right", "input_up", "input_down")
	
	velocity = direction * ((BASE_SPEED * speed_multiplier) + speed_modifier)
	
	# prevent from trying to move diagonally when blocked from the top or bottom
	if (is_on_ceiling() or is_on_floor()) and direction.y != 0:
		velocity.x = roundi(direction.x) * ((BASE_SPEED * speed_multiplier) + speed_modifier)
		
	# prevent from trying to move diagonally when blocked from the sides
	if is_on_wall() and direction.x != 0: 
		velocity.y = roundi(direction.y) * ((BASE_SPEED * speed_multiplier) + speed_modifier)
	
	#print("w=%s, c=%s, f=%s" % [is_on_wall(), is_on_ceiling(), is_on_floor()])
	move_and_slide()
	
	if can_fire and Input.is_action_pressed("fire"):
		do_attack(delta)
		if !firing: firing = true
		
	if Input.is_action_just_released("fire"):
		firing = false


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventAction: return
	
	if Input.is_action_just_pressed("ability_menu"):
		GameManager.open_ability_menu()
	elif Input.is_action_just_pressed("ability"):
		if ability_queue.is_empty(): return
		var a = ability_queue.pop_front()
		print("ability=", a.name)
	elif Input.is_action_just_pressed("escape_menu"):
		print("escape menu")


func do_attack(delta : float) -> void:
	weapon._attack(delta, global_position, Vector2.RIGHT)
	#weapon._attack(global_position, position.direction_to(get_global_mouse_position()))


func invulnerable() -> void:
	$Hurtbox/Collider.disabled = true


func _on_hit(bullet : Bullet) -> void:
	# TODO: handle damaging player here; check if area is an enemy attack or a hazard
	#print("'%s' hit the player..." % [bullet.name])
	current_health = clampi(current_health - bullet.damage, 0, max_health)
	if current_health == 0:
		print("DEAD")
		sprite.self_modulate.a = 0.5
		set_physics_process(false)
		invulnerable()
		return
	
	# TODO: damage ani & iframes


# TODO: implement collecting power-ups. when change stats, should updat all projectile stats too

func _on_grazed() -> void:
	#print("grazed")
	pass
