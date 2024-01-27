extends Node


const SFX := {
	"player_fire": "",
	"player_damaged": preload("res://assets/audio/sfx/player_damaged.wav"),
	"player_death": preload("res://assets/audio/sfx/player_death.wav"),
	"enemy_death": preload("res://assets/enemies/assets/enemy_death.wav"),
	"power_up": preload("res://assets/levels/assets/Power-up.wav"),
	"collect": preload("res://assets/audio/sfx/collect.wav"),
	"generator": preload("res://assets/audio/sfx/Laser - 3.wav")
}

const SFX_VOLUME := {
	"player_damaged": 10,
	"player_death": -10,
	"enemy_death": 0,
	"power_up": 0,
	"collect": -8,
	"generator": -10
}


const BGM := {
	"main_menu": preload("res://assets/audio/songs/main_menu_120_bpm.wav"),
	"stage_1": preload("res://assets/audio/songs/stage_1_135_bpm.wav"),
	"game_over": preload("res://assets/menus/assets/audio/4. GameOver (Loop).wav"),
	"win": preload("res://assets/audio/songs/You Win_level complete.wav")
}


const BGM_VOLUME := {
	"main_menu": -10,
	"stage_1": -15,
	"game_over": -12
}


@onready var player_sfx_player : AudioStreamPlayer = $player_sfx
@onready var enemy_death_player : AudioStreamPlayer = $enemy_death_player
@onready var bgm_player : AudioStreamPlayer = $bgm_player
@onready var sfx_player : AudioStreamPlayer = $sfx


#var bgm_volume : float = -10.0

var t : float = 0.0

func _ready() -> void:
	var stream : AudioStreamWAV = SFX["enemy_death"]
	enemy_death_player.max_polyphony = 10
	enemy_death_player.set_stream(stream)
	player_sfx_player.volume_db = 10
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if bgm_player.volume_db <= -80:
		t = 0
		set_physics_process(false)
		return
	t += delta * 30
	if t >= 1:
		t = 0
		bgm_player.volume_db -= 0.5
		

func player_sfx(name : String) -> void:
	player_sfx_player.volume_db = SFX_VOLUME.get(name, 0)
	player_sfx_player.set_stream(SFX.get(name, "player_damaged"))
	player_sfx_player.play()
		

func play_sfx(name : String) -> void:
	sfx_player.volume_db = SFX_VOLUME.get(name, 0)
	sfx_player.set_stream(SFX.get(name, "player_damaged"))
	sfx_player.play()


func play_bgm(name : String) -> void:
	set_physics_process(false)
	if !BGM.has(name): 
		push_warning("Song '%s' not found." % [name])
		return
	bgm_player.set_stream(BGM[name])
	bgm_player.set_volume_db(BGM_VOLUME.get(name, -10))
	bgm_player.play()


func fade_bgm() -> void:
	set_physics_process(true)

var can_play_death_sfx : bool = true

func enemy_death() -> void:
	if !can_play_death_sfx: return
	can_play_death_sfx = false
	enemy_death_player.pitch_scale = randf_range(0.5, 1.5)
	enemy_death_player.play()
	get_tree().create_timer(0.05).timeout.connect(func(): can_play_death_sfx = true)
