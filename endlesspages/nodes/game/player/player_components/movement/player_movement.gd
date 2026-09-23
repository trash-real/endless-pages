class_name PlayerMovement
extends PlayerComponent

enum MovementState { STILL, WALKING, RUNNING, }

var _input: InputComponent
var _camera: PlayerCameraRotation


func init() -> void:
	super.init()
	_input = _player.components.get_component(InputComponent)
	_camera = _player.components.get_component(PlayerCameraRotation)
	
	create_bind(_input.run_pressed, _on_input_run_pressed)
	create_bind(_input.run_released, _on_input_run_released)
	create_bind(Constraints.changed, _on_constraints_changed)


func physics_tick(delta: float) -> void:
	var input := _input.get_movement_direction()
	
	# Get camera facing directions
	var forward := _camera.get_forward_vector().normalized()
	var right := _camera.get_right_vector().normalized()
	
	# No vertical movement
	forward.y = 0.0
	right.y = 0.0
	
	# Combine movement input with camera directions
	var direction := (right * input.x + forward * input.z).normalized()
	
	# Apply
	var lerp_delta := Shortcuts.get_lerp_delta(_player.stats.move_acceleration, delta)
	_player.velocity.x = lerpf(_player.velocity.x, direction.x * _get_speed(), lerp_delta)
	_player.velocity.z = lerpf(_player.velocity.z, direction.z * _get_speed(), lerp_delta)
	
	var moving := direction != Vector3.ZERO
	if moving and _player.movement_state.get_state() == MovementState.STILL:
		_on_begin_moving()
	elif not moving:
		_change_state(MovementState.STILL)


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


func _change_state(new: MovementState):
	if Constraints.has(Constraint.Type.RUN_LOCKED) and new == MovementState.RUNNING:
		return
	
	_player.movement_state.request(new)


func _on_begin_moving() -> void:
	if _input.is_running():
		_change_state(MovementState.RUNNING)
	else:
		_change_state(MovementState.WALKING)


#region Signal Connections
func _on_input_run_pressed() -> void:
	if _player.velocity != Vector3.ZERO:
		_change_state(MovementState.RUNNING)


func _on_input_run_released() -> void:
	if _player.velocity != Vector3.ZERO:
		_change_state(MovementState.WALKING)
	else:
		_change_state(MovementState.STILL)


func _on_constraints_changed() -> void:
	if Constraints.has(Constraint.Type.RUN_LOCKED) and _player.movement_state.get_state() == MovementState.RUNNING:
		_change_state(MovementState.WALKING)
#endregion
