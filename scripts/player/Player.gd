class_name Player extends CharacterBody2D


signal stats_changed()


const BASE_SPEED := 150.0


@onready var grazebox : Grazebox = $Grazebox
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var weapon : Weapon = $Weapon
@onready var abilities : Node = $Abilities # meant for use with the cards
@onready var animator : AnimationPlayer = $AnimationPlayer


## Health
@export var health := 50:
	set(value):
		health = value
		stats_changed.emit()
## Attack
@export var attack := 5:
	set(value):
		attack = value
		stats_changed.emit()
## Movement speed
@export var speed_modifier := 0:
	set(value):
		speed_modifier = value
		stats_changed.emit()
@export var focus_speed := 0.375


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_fire : bool = true
var firing : bool = false
var speed_multiplier : float = 1.0

var camera : Cammaku
var screen_extents : Vector2


func _ready() -> void:
	hurtbox.hit.connect(_on_hit)
	grazebox.grazed.connect(_on_grazed)
	camera = get_tree().get_first_node_in_group("camera") as Cammaku
	screen_extents = get_viewport_rect().size / (2 * camera.zoom)


func _physics_process(delta : float) -> void:
	if Input.is_action_pressed("focus"):
		speed_multiplier = focus_speed
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
	if not event is InputEventKey and not event is InputEventAction and not event is InputEventMouseButton: return
	
	#if can_fire and Input.is_action_pressed("fire"):
		#_on_do_attack()
		#if !firing: firing = true
		

func _on_hit(bullet : Bullet) -> void:
	# TODO: handle damaging player here; check if area is an enemy attack or a hazard
	#print("'%s' hit the player..." % [bullet.name])
	pass


func do_attack(delta : float) -> void:
	weapon._attack(delta, global_position, Vector2.RIGHT)
	#weapon._attack(global_position, position.direction_to(get_global_mouse_position()))


# TODO: implement collecting power-ups. when change stats, should updat all projectile stats too


func _on_grazed() -> void:
	#print("grazed")
	pass
