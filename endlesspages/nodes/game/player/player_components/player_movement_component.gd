class_name PlayerMovementComponent
extends PlayerComponent

enum MovementState { STILL, WALKING, RUNNING }

var _input: PlayerInputComponent


func init() -> void:
	super.init()
	_input = _player.components.get_component(PlayerInputComponent)


func physics_tick(_delta: float) -> void:
	var previous_vel := _player.velocity
	var direction = _input.get_movement_direction().normalized()
	
	_player.velocity.x = direction.x * _player.stats.walk_speed
	_player.velocity.z = direction.y * _player.stats.walk_speed
	
	if previous_vel == Vector3.ZERO and _player.velocity != Vector3.ZERO:
		_on_begin_moving()


func _change_state(new: MovementState):
	_player.movement_state.request(new)


func deactivate() -> void:
	pass


func _on_begin_moving() -> void:
	if _input.is_running():
		_change_state(MovementState.RUNNING)
	else:
		_change_state(MovementState.WALKING)
