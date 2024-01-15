class_name Player extends CharacterBody2D


const SPEED := 100.0


@onready var grazebox : Grazebox = $Grazebox
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var weapon : Weapon = $Weapon
@onready var abilities : Node = $Abilities # meant for use with the cards
@onready var animator : AnimationPlayer = $AnimationPlayer


@export var stats : Stats


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	hurtbox.hit.connect(_on_hit)
	weapon.attack_timer.timeout.connect(_on_do_attack)
	weapon._start(self)
	grazebox.grazed.connect(_on_grazed)


func _physics_process(delta : float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : Vector2 = Input.get_vector("input_left", "input_right", "input_up", "input_down")
	velocity = direction * SPEED
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey and not event is InputEventAction and not event is InputEventMouseButton: return
	
	#if Input.is_action_just_pressed(&"left_click"):
		#_on_do_attack()

func _on_hit(bullet : Bullet) -> void:
	# TODO: handle damaging player here; check if area is an enemy attack or a hazard
	#print("'%s' hit the player..." % [bullet.name])
	pass


func _on_do_attack() -> void:
	weapon._attack(global_position, Vector2.RIGHT)
	#weapon._attack(global_position, position.direction_to(get_global_mouse_position()))


# TODO: implement collecting power-ups. when change stats, should updat all projectile stats too


func _on_grazed() -> void:
	#print("grazed")
	pass
