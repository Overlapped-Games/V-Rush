extends Node


const MAX_SCORE : int = 999_999_999_999

const STAGES := {
	1: preload("res://assets/levels/stage_1.tscn"),
	2: preload("res://assets/levels/stage_1.tscn"),
	3: preload("res://assets/menus/scenes/game_over.tscn"),
	100: preload("res://assets/test_levels/test_boss.tscn")
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


const POWER_UPS := {
	1: preload("res://assets/collectibles/attack_up.tscn"),
	2: preload("res://assets/collectibles/gauge_up.tscn"),
}

@onready var collect_fx : PackedScene = preload("res://assets/fx/collect_fx.tscn")
@onready var collect_fx_small : PackedScene = preload("res://assets/fx/collect_fx_small.tscn")

@onready var health : RichTextLabel = %HealthCounter
@onready var gauge : TextureProgressBar = $CanvasLayer/VRushGauge
@onready var score_label : RichTextLabel = %Score
@onready var hi_score_label : RichTextLabel = %HiScore
@onready var power_stage_icons : HBoxContainer = %PowerIcons

var player : Player
var current_level : int = 1
var process : bool = true
var gauge_ready := false
var v_rush_menu_open := false
var score := 0:
	set(value):
		score = clamp(value, 0, MAX_SCORE)
		score_label.text = "[right]%012d[/right]" % score


func _ready() -> void:
	var window : Window = get_tree().root
	window.size = Vector2(1280, 720)
	visible_canvas(false)
	#var mainMenuScene = preload("res://assets/menus/scenes/main_menu.tscn")
	#var mainMenuInit = mainMenuScene.instantiate()
	#add_child(mainMenuInit)
	#player = get_tree().get_first_node_in_group("player")
	var level : Level = get_tree().get_first_node_in_group("level")
	if level:
		call_deferred("init_level", level.level)


func init_level(level : int) -> void:
	current_level = level
	visible_canvas(true)
	var bg = get_tree().get_first_node_in_group("level_background")
	bg.set_target_color(get_background_color(current_level))
	init_stat()


func start_level(level : int) -> void:
	current_level = level
	visible_canvas(true)
	get_tree().change_scene_to_packed(STAGES[current_level])
	await get_tree().create_timer(0.01).timeout
	var bg = get_tree().get_first_node_in_group("level_background")
	bg.set_target_color(get_background_color(current_level))
	init_stat()
	#BulletUtil.reparent(get_tree().get_first_node_in_group("stage"))


func init_stat() -> void:
	reset_gauge()
	player = get_tree().get_first_node_in_group("player")
	player.defeated.connect(_on_player_defeated)
	player.grazed.connect(_on_player_grazed)
	player.health_updated.connect(func(new_health : int): health.text = "[color=%s]%02d[/color]" % ["green" if new_health > 10 else "red", new_health])
	player.weapon.stage_changed.connect(_on_weapon_stage_changed)
	health.text = "[color=%s]%02d[/color]" % ["green" if player.current_health > 10 else "red", player.current_health]
	score_label.text = "[right]%012d[/right]" % score # sets digits to 12 digits, fills unused with 0s


func get_background_color(level : int) -> Color:
	return level_colors[level - 1] if level < level_colors.size() else level_colors[0]


func visible_canvas(arg: bool) -> void:
	$CanvasLayer.visible = arg


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


func reset_gauge() -> void:
	gauge.value = 0
	gauge_ready = false


# TODO: 
func open_skill_menu() -> void:
	if !v_rush_menu_open and gauge_ready:
		v_rush_menu_open = true
		#print("open gauge")
		gauge.value = 0
		gauge_ready = false
		# TODO: freeze game physics processing, except for the menu


func clean_up_bullets():
	pass # TODO: implement


func fill_gauge(value := 5) -> void:
	if gauge.value < 100:
		gauge.value += value * player.gauge_fill_rate
		
		if gauge.value >= 100:
			#print("gauge ready")
			gauge_ready = true


func _on_player_defeated():
	clean_up_bullets()
	get_tree().change_scene_to_packed(STAGES[3])
	await get_tree().create_timer(0.01).timeout


func _on_player_grazed() -> void:
	fill_gauge()
	score += 100


func _on_scorable_hit(value : int) -> void:
	score += value


# small enemy = 500
# medium enemy = 1000
# big enemy = 2000
func _on_enemy_hit(enemy : Enemy) -> void:
	score += 100


func _on_enemy_defeated(enemy : Enemy) -> void:
	score += 1000
	
	var power_up : Area2D = POWER_UPS[randi_range(1, 2)].instantiate()
	get_tree().get_first_node_in_group("scroller").add_child(power_up)
	#power_up.set_as_top_level(true)
	power_up.global_position = enemy.global_position
	
	if enemy.is_in_group("boss"):
		_on_boss_defeated(enemy)


func _on_boss_defeated(enemy : Enemy) -> void:
	score += enemy.defeat_value if enemy.get("defeat_value") else 10000
	# TODO end level and play fanfare
	get_tree().paused = true
	AudioManager.play_bgm("win")
	BulletUtil._on_win()
	$CanvasLayer.hide()
	$WIN.win()


func _on_weapon_stage_changed(stage : int) -> void:
	for i in range(power_stage_icons.get_child_count() - 1, -1 , -1):
		if i + 1 > stage:
			power_stage_icons.get_child(i).frame = 15
		else:
			power_stage_icons.get_child(i).frame = 16


func get_level() -> int:
	return current_level


func set_level(arg: int) -> void:
	current_level = arg


