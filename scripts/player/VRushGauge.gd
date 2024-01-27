class_name VRushGauge extends TextureProgressBar


func _ready() -> void:
	value_changed.connect(_on_value_updated)


func _physics_process(delta: float) -> void:
	if value == 100:
		#print("change colors")
		tint_progress.h += delta / 2
		if tint_progress.h == 1:
			tint_progress.h = 0
	else:
		tint_progress.h = 0
		tint_progress.s = 0
		set_physics_process(false)


func _on_value_updated(value : int) -> void:
	if value == 100:
		tint_progress.s = 0.75
		#print_rich("[wave][rainbow]READY[/rainbow][/wave]")
		set_physics_process(true)
