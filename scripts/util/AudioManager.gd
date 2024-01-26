extends Node


const SFX := {
	"player_fire": "",
	"player_damaged": preload("res://assets/audio/sfx/player_damaged.wav"),
	"player_death": preload("res://assets/audio/sfx/player_death.wav"),
	"enemy_death": preload("res://assets/enemies/assets/enemy_death.wav")
}


const BGM := {
	"main_menu": preload("res://assets/audio/songs/main_menu_120_bpm.wav"),
	"stage_1": preload("res://assets/audio/songs/stage_1_135_bpm.wav"),
	"game_over": preload("res://assets/menus/assets/audio/4. GameOver (Loop).wav")
}


@onready var player_sfx_player : AudioStreamPlayer = $player_sfx
@onready var enemy_death_player : AudioStreamPlayer = $enemy_death_player
@onready var bgm_player : AudioStreamPlayer = $bgm_player


var bgm_volume : float = -10.0

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
	player_sfx_player.volume_db = 10 if name == "player_damaged" else -10 if name == "player_death" else 0
	player_sfx_player.set_stream(SFX.get(name, "player_damaged"))
	player_sfx_player.play()


func play_bgm(name : String) -> void:
	set_physics_process(false)
	if !BGM.has(name): 
		push_warning("Song '%s' not found." % [name])
		return
	bgm_player.set_stream(BGM[name])
	bgm_player.set_volume_db(bgm_volume)
	bgm_player.play()


func fade_bgm() -> void:
	set_physics_process(true)


func enemy_death() -> void:
	#AudioEffectPitchShift
	enemy_death_player.pitch_scale = randf_range(0.5, 1.5)
	#enemy_death_player.pitch_scale
	enemy_death_player.play()
