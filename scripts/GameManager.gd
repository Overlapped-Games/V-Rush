extends Node


@onready var gauge : TextureProgressBar = $Gauge
@onready var score_label : RichTextLabel = $Score

var player : Player

var gauge_ready := false
var v_rush_menu_open := false
var score := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window : Window = get_tree().root
	window.size = Vector2(1280, 720)
	
	player = get_tree().get_first_node_in_group("player")


func _input(event: InputEvent) -> void:
	if !v_rush_menu_open or (not event is InputEventKey and not event is InputEventAction): return
	
	var direction : Vector2 = Input.get_vector("input_left", "input_right", "input_up", "input_down")
	
	if direction and not event.is_echo():
		print("moving=", direction)
		# TODO: implement navigating menu


# TODO: 
func open_ability_menu() -> void:
	if !v_rush_menu_open and gauge_ready:
		v_rush_menu_open = true
		print("open gauge")
		# TODO: freeze game physics processing, except for the menu


func _on_player_grazed() -> void:
	if gauge.value < 100:
		gauge.value += 5 * player.gauge_fill_rate
		
		if gauge.value >= 100:
			print("gauge ready")
			gauge_ready = true

# small enemy = 500
# medium enemy = 1000
# big enemy = 2000
func _on_enemy_hit(enemy : Enemy) -> void:
	score += 1000
