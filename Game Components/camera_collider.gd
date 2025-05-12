extends Node3D

## The distance from the player that the camera should be by default
@export var target_distance: float = 8

## Smoothing factor for returning to the target distance. Higher is faster
@export_range(1, 50, 0.1, "or_greater") var smooth_speed: float = 8

@onready var parent: Node3D = get_parent()

## The current distance from the player
var curr_distance: float = 0:
	set(value):
		curr_distance = value
		position.z = curr_distance


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		hide()
		return
	curr_distance = lerp(curr_distance, target_distance, smooth_speed * delta)
	var space_state = get_world_3d().direct_space_state
	var origin = parent.global_position
	var end = origin + global_transform.basis.z.normalized() * curr_distance
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collision_mask = 1 << 1

	var result = space_state.intersect_ray(query)
	if result.size() > 0:
		var pos: Vector3 = result.position
		var dist = (pos - parent.global_position).length()
		if dist < curr_distance:
			curr_distance = dist
