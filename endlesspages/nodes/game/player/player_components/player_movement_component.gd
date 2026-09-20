class_name PlayerMovementComponent
extends PlayerComponent

enum MovementState { STILL, WALKING, RUNNING }

var _input: InputComponent
var _camera: PlayerCameraComponent


func init() -> void:
	super.init()
	_input = _player.components.get_component(InputComponent)
	_camera = _player.components.get_component(PlayerCameraComponent)
	
	_input.run_pressed.connect(_on_input_run_pressed)
	_input.run_released.connect(_on_input_run_released)


func physics_tick(_delta: float) -> void:
	var previous_vel := _player.velocity
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
	_player.velocity.x = direction.x * _get_speed()
	_player.velocity.z = direction.z * _get_speed()
	
	if previous_vel == Vector3.ZERO and _player.velocity != Vector3.ZERO:
		_on_begin_moving()
	if previous_vel != Vector3.ZERO and _player.velocity == Vector3.ZERO:
		_change_state(MovementState.STILL)


func _get_speed() -> float:
	match _player.movement_state.get_state():
		MovementState.WALKING:
			return _player.stats.walk_speed
		MovementState.RUNNING:
			return _player.stats.run_speed
		_:
			return _player.stats.walk_speed


func _change_state(new: MovementState):
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
#endregion
