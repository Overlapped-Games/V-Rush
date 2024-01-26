extends Node


const MAX_SCORE : int = 999_999_999_999

const STAGES := {
	1: "res://assets/levels/stage_1.tscn",
	2: "res://assets/levels/stage_1.tscn",
	3: "res://assets/menus/scenes/game_over.tscn"
}

const level_colors : Array[Color] = [
	Color(0.00, 0.75, 1.00),
	Color(1.00, 0.20, 0.50),
	Color(1.00, 0.40, 0.20),
	Color(1.00, 0.80, 0.00),
	Color(0.00, 1.00, 0.50),
	Color(1.00, 0.10, 0.00),
	Color(1.00, 1.00, 0.00),
]



@onready var health : RichTextLabel = %HealthCounter
@onready var gauge : TextureProgressBar = $CanvasLayer/VRushGauge
@onready var score_label : RichTextLabel = %Score

var player : Player
var current_level : int = 1
var process : bool = true
var gauge_ready := false
var v_rush_menu_open := false
var score := 0:
	set(value):
		score = clamp(value, 0, MAX_SCORE)
		score_label.text = "%012d" % score


func _ready() -> void:
	var window : Window = get_tree().root
	window.size = Vector2(1280, 720)
	visible_canvas(false)
	var mainMenuScene = preload("res://assets/menus/scenes/main_menu.tscn")
	var mainMenuInit = mainMenuScene.instantiate()
	add_child(mainMenuInit)
	#player = get_tree().get_first_node_in_group("player")


func start_level(level : int) -> void:
	current_level = level
	visible_canvas(true)
	get_tree().change_scene_to_file(STAGES[current_level])
	await get_tree().create_timer(0.01).timeout
	var bg = get_tree().get_first_node_in_group("level_background")
	bg.set_target_color(get_background_color(current_level))
	init_stat()


func init_stat() -> void:
	visible_menu(false)
	player = get_tree().get_first_node_in_group("player")
	player.defeated.connect(_on_player_defeated)
	player.grazed.connect(_on_player_grazed)
	player.health_updated.connect(func(new_health : int): health.text = "[color=%s]%02d[/color]" % ["green" if new_health > 10 else "red", new_health])
	health.text = "[color=%s]%02d[/color]" % ["green" if player.current_health > 10 else "red", player.current_health]
	score_label.text = "%012d" % score # sets digits to 12 digits, fills unused with 0s


func get_background_color(level : int) -> Color:
	return level_colors[level - 1]


func visible_canvas(arg: bool) -> void:
	$CanvasLayer.visible = arg


func visible_menu(arg: bool) -> void:
	$Main_Menu.visible = arg

func remove_child_by_name(childName: String) -> void:
	if has_node(childName):
		var node = get_node(childName)
		node.queue_free()

func hide_child_by_name(childName: String) -> void:
	if has_node(childName):
		var node = get_node(childName)
		node.visible = false

func get_node_by_name(node_name: String):
	if has_node(node_name):
		var node = get_node(node_name)
		return node
	

#func _input(event: InputEvent) -> void:
	#if !v_rush_menu_open or (not event is InputEventKey and not event is InputEventAction): return
	#
	#var direction : Vector2 = Input.get_vector("input_left", "input_right", "input_up", "input_down")
	#
	#if direction and not event.is_echo():
		#print("moving=", direction)
		## TODO: implement navigating menu


func can_equip_skill() -> bool:
	return false


# TODO: 
func open_skill_menu() -> void:
	if !v_rush_menu_open and gauge_ready:
		v_rush_menu_open = true
		print("open gauge")
		gauge.value = 0
		gauge_ready = false
		# TODO: freeze game physics processing, except for the menu


func clean_up_bullets():
	pass # TODO: implement


func _on_player_defeated():
	clean_up_bullets()
	get_tree().change_scene_to_file(STAGES[3])
	await get_tree().create_timer(0.01).timeout


func _on_player_grazed() -> void:
	if gauge.value < 100:
		gauge.value += 5 * player.gauge_fill_rate
		
		if gauge.value >= 100:
			print("gauge ready")
			gauge_ready = true


func _on_scorable_hit(value : int) -> void:
	score += value


# small enemy = 500
# medium enemy = 1000
# big enemy = 2000
func _on_enemy_hit(enemy : Enemy) -> void:
	score += 100


func _on_enemy_defeated(enemy : Enemy) -> void:
	score += 1000


func _on_boss_defeated(enemy : Enemy) -> void:
	score += enemy.defeat_value if enemy.get("defeat_value") else 10000

func get_level() -> int:
	return current_level

func set_level(arg: int) -> void:
	current_level = arg


