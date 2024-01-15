class_name Stats extends Resource


signal stats_changed(stats : Stats)


## Health
@export var health := 5:
	set(value):
		health = value
		stats_changed.emit(self)
## Attack
@export var attack := 5:
	set(value):
		attack = value
		stats_changed.emit(self)
## Movement speed
@export var speed := 10:
	set(value):
		speed = value
		stats_changed.emit(self)
