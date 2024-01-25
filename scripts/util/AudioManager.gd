extends Node


const SFX := {
	"player_fire": "",
	"enemy_death": preload("res://assets/enemies/assets/enemy_death.wav")
}


var enemy_death_player : AudioStreamPlayer


func _ready() -> void:
	enemy_death_player = AudioStreamPlayer.new()
	add_child(enemy_death_player)
	var stream : AudioStreamWAV = SFX["enemy_death"]
	enemy_death_player.max_polyphony = 10
	enemy_death_player.set_stream(stream)
	#enemy_death_player.play()
	print(SFX["enemy_death"])


func play(name : String) -> void:
	SFX.get(name, "").play()


func enemy_death() -> void:
	#AudioEffectPitchShift
	enemy_death_player.pitch_scale = randf_range(0.5, 1.5)
	#enemy_death_player.pitch_scale
	enemy_death_player.play()
