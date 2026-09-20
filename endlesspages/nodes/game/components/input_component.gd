class_name InputComponent
extends Component
## Tracks user input. 
##
## Fires signals for player action triggers and has methods for getting state of other actions.

signal run_pressed
signal run_released
signal light_toggled
signal interacted
signal mouse_motion(relative: Vector2)


#region Input
func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return
	
	if event is InputEventKey:
		_handle_key_input(event)
	elif event is InputEventMouseButton:
		_handle_mouse_button_input(event)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion_input(event)


func _handle_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("player_run"):
		run_pressed.emit()
	elif event.is_action_released("player_run"):
		run_released.emit()
	
	if event.is_action_pressed("player_toggle_light"):
		light_toggled.emit()


func _handle_mouse_button_input(event: InputEventMouseButton) -> void:
	if event.is_action_pressed("player_interact"):
		interacted.emit()


func _handle_mouse_motion_input(event: InputEventMouseMotion) -> void:
	mouse_motion.emit(event.relative)
#endregion


#region Helpers
func get_movement_direction() -> Vector3:
	if not enabled:
		return Vector3.ZERO
	
	var dir = Input.get_vector(
		"player_move_left", "player_move_right",
		"player_move_backward", "player_move_forward"
		)
	
	return Vector3(dir.x, 0.0, dir.y)


func is_running() -> bool:
	return Input.is_action_pressed("player_run")
#endregion
