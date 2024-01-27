extends MoveLeft


var actor : Node


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	# Enemy went out of view left
	if actor.global_position.x < camera.global_position.x - 32 - camera.get_viewport_rect().size.x / 2:
		actor.queue_free()
		return
		
	actor.global_position.x += (Vector2.LEFT.x * delta * (speed if speed > 0 else actor.speed))


func tick(actor: Node, blackboard: Blackboard) -> int:
	self.actor = actor
	set_physics_process(true)
	return SUCCESS
