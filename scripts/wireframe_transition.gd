extends Sprite2D

var transition_speed : float = 0.01
var target_color : Color

func _ready():
	self.modulate = Color(0.00, 0.75, 1.00, 1)

func _process(delta: float) -> void:
	change_color(transition_speed)

func change_color(speed: float) -> void:
	if modulate != target_color:
		modulate.r = approach(modulate.r, target_color.r, speed)
		modulate.g = approach(modulate.g, target_color.g, speed)
		modulate.b = approach(modulate.b, target_color.b, speed)
		modulate.a = approach(modulate.a, target_color.a, speed)

func set_target_color(new_target_color: Color) -> void:
	target_color = new_target_color

func approach(current: float, target: float, speed: float) -> float:
	if current < target:
		return min(current + speed, target)
	elif current > target:
		return max(current - speed, target)
	else:
		return current
