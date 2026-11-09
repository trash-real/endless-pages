class_name PlayerMovement
extends PlayerComponent

enum MovementState { STILL, WALKING, RUNNING, }

var _input: InputComponent
var _camera: PlayerCameraRotation


func init() -> void:
	super.init()
	_input = _player.components.get_component(InputComponent)
	_camera = _player.components.get_component(PlayerCameraRotation)


func physics_tick(delta: float) -> void:
	var input := _input.get_movement_direction()
	
	var forward := _camera.get_forward_vector()
	var right := _camera.get_right_vector()
	forward.y = 0.0
	right.y = 0.0
	
	var direction := (right.normalized() * input.x + forward.normalized() * input.z).normalized()
	
	# Decide state first so speed is correct this frame
	var desired := _get_desired_state(direction != Vector3.ZERO)
	if desired != _player.movement_state.get_state():
		_player.movement_state.request(desired)
	
	var lerp_delta := Shortcuts.get_lerp_delta(_player.stats.move_acceleration, delta)
	_player.velocity.x = lerpf(_player.velocity.x, direction.x * _get_speed(), lerp_delta)
	_player.velocity.z = lerpf(_player.velocity.z, direction.z * _get_speed(), lerp_delta)
	
	_error_checks()


func _get_desired_state(moving: bool) -> MovementState:
	if not moving:
		return MovementState.STILL
	if _can_run():
		return MovementState.RUNNING
	return MovementState.WALKING


func deactivate() -> void:
	_player.movement_state.request(MovementState.STILL)


func _get_speed() -> float:
	match _player.movement_state.get_state():
		MovementState.WALKING:
			return _player.stats.move_walk_speed
		MovementState.RUNNING:
			return _player.stats.move_run_speed
		_:
			return _player.stats.move_walk_speed


func _can_run() -> bool:
	# Not inputting run
	if not _input.is_running():
		return false
	# Can only run while moving forward
	if not _input.get_movement_direction().z > 0.0:
		return false
	# Run locked
	if Constraints.has(Constraint.Type.RUN_LOCKED):
		return false
	return true


func _error_checks() -> void:
	if _player.movement_state.get_state() == MovementState.RUNNING and not _input.is_running():
		push_error("stuck running: moving = ", _input.get_movement_direction() != Vector3.ZERO, " can_run = ", _can_run())
