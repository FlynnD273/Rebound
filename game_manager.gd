extends Node3D
class_name GameManager

@export var rock_scene: PackedScene

var target_position := Vector3.ZERO
var rock_parent: Node
var hovered_rock: RockController:
	set(value):
		if value == hovered_rock:
			return
		if is_instance_valid(hovered_rock):
			hovered_rock.outlined = false
		hovered_rock = value
		hovered_rock.outlined = true

var window: Window


func _ready() -> void:
	window = get_viewport().get_window()

	rock_parent = Node.new()
	add_child(rock_parent)


func spawn_rock() -> void:
	var rock: RockController = rock_scene.instantiate()
	rock_parent.add_child(rock)
	rock.position = (Vector3.RIGHT * 20) + Vector3.UP * 5
	rock.linear_velocity = (target_position - rock.position) / 2
	rock.angular_velocity = (
		Vector3(-rock.linear_velocity.z, 0, -rock.linear_velocity.x) / 3
	)
	rock.linear_velocity.y = 2


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Fullscreen"):
		if window.mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
			window.mode = Window.MODE_WINDOWED
		else:
			window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
