extends CharacterBody3D

@export var game_manager: GameManager
@export var player_camera: Camera3D
@export var gravity: Vector3 = Vector3.DOWN * 98

@export_group("Jumping")
## Time in seconds that the player can still jump after leaving the ground
@export var coyote_time: float = 0.1
var coyote_timer: Timer
var was_on_floor := false
var has_jumped := true
var can_float := false

@export var base_jump_height: float = 30
## Amount to add to vertical velocity if the player holds jump
@export var variable_jump_float: float = 20

@export_group("Movement")
## Horizontal movement speed multiplier
@export var movement_speed: float = 5

## Horizontal movement velocity multiplier
@export var movement_friction: float = 0.8

@export_group("Grabbed Rocks")
## Amount the rock gets pulled
@export var rock_pull: float = 1
## Amount the player gets pulled
@export var player_pull: float = 5

var grabbed_rock: RockController


func _ready() -> void:
	coyote_timer = Timer.new()
	coyote_timer.name = "Coyote Timer"
	coyote_timer.one_shot = true
	add_child(coyote_timer)


func _physics_process(delta: float) -> void:
	if not is_instance_valid(grabbed_rock):
		var min_dist: float = 9999
		var rock: RockController
		for curr_rock in game_manager.rock_parent.get_children():
			var dist: float = (curr_rock.global_position - global_position).length_squared()
			if dist < min_dist:
				min_dist = dist
				rock = curr_rock
		if is_instance_valid(rock):
			game_manager.hovered_rock = rock
			if Input.is_action_just_pressed("Grab"):
				grabbed_rock = rock
	if Input.is_action_just_released("Grab"):
		grabbed_rock = null
	velocity += gravity * delta
	var movement_input := Input.get_vector("Left", "Right", "Up", "Down") * movement_speed
	movement_input *= delta
	movement_input = movement_input.rotated(-player_camera.global_rotation.y)
	velocity.x += movement_input.x
	velocity.z += movement_input.y
	velocity.x *= movement_friction
	velocity.z *= movement_friction
	var on_floor := is_on_floor()
	if on_floor:
		coyote_timer.stop()
		if not Input.is_action_pressed("Jump"):
			has_jumped = false
	elif was_on_floor:
		coyote_timer.start()
	if (
		not has_jumped
		and (not coyote_timer.is_stopped() or on_floor)
		and Input.is_action_pressed("Jump")
	):
		velocity.y = base_jump_height
		has_jumped = true
		can_float = true
	if velocity.y > 0 and Input.is_action_pressed("Jump") and can_float:
		velocity.y += variable_jump_float * delta
	if not Input.is_action_pressed("Jump"):
		can_float = false
	was_on_floor = is_on_floor()
	if is_instance_valid(grabbed_rock):
		var diff := global_position - grabbed_rock.global_position
		grabbed_rock.linear_velocity += (
			(diff.normalized() * rock_pull * diff.length_squared()) * delta
		)
		if Input.is_action_pressed("Pull"):
			velocity += -(diff.normalized() * player_pull * diff.length_squared()) * delta
	move_and_slide()
