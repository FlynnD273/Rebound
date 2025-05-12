extends RigidBody3D
class_name RockController

static var rock_total := 0
var id: int


func _ready() -> void:
	id = rock_total
	rock_total += 1


@export var outline_material: Material
@export var outlined := false:
	set(value):
		outlined = value
		for child in $Rock.get_children(true):
			if child is MeshInstance3D:
				var mesh_instance := child as MeshInstance3D
				for i in mesh_instance.get_surface_override_material_count():
					if outlined:
						var new_mat: Material = mesh_instance.get_active_material(i).duplicate()
						new_mat.next_pass = outline_material
						mesh_instance.set_surface_override_material(i, new_mat)
					else:
						mesh_instance.set_surface_override_material(i, null)

@rpc("any_peer", "call_local", "unreliable_ordered")
func add_force(force: Vector3) -> void:
	linear_velocity += force
