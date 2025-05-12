extends Node3D

@export var head: Node3D


func _ready() -> void:
	if not is_multiplayer_authority():
		hide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SETTINGS.mouse_sensitivity)
		head.rotate_x(-event.relative.y * SETTINGS.mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, -PI / 2, PI / 2)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Exit"):
		Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
