extends Node2D


@onready var direct_space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state


func intersect_shape(query : PhysicsShapeQueryParameters2D, max_results := 32) -> Array[Dictionary]:
	return direct_space_state.intersect_shape(query, max_results)
