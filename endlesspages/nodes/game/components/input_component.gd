class_name InputComponent
extends Component
## Tracks user input. 
##
## Fires signals for player action triggers and has methods for getting state of other actions.

signal run_pressed
signal run_released
signal light_pressed
signal light_released
signal interact_pressed
signal interact_released
signal mouse_motion(relative: Vector2)


#region Input
func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build():
		_handle_debug_input(event)
	
	if not enabled:
		return
	
	if event is InputEventKey:
		_handle_key_input(event)
		return
	elif event is InputEventMouseButton:
		_handle_mouse_button_input(event)
		return
	elif event is InputEventMouseMotion:
		_handle_mouse_motion_input(event)
		return


func _handle_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("player_run"):
		run_pressed.emit()
	elif event.is_action_released("player_run"):
		run_released.emit()
	
	if event.is_action_pressed("player_toggle_light"):
		light_pressed.emit()
	elif event.is_action_pressed("player_toggle_light"):
		light_released.emit()


func _handle_mouse_button_input(event: InputEventMouseButton) -> void:
	if event.is_action_pressed("player_interact"):
		interact_pressed.emit()
	elif event.is_action_released("player_interact"):
		interact_released.emit()


func _handle_mouse_motion_input(event: InputEventMouseMotion) -> void:
	mouse_motion.emit(event.relative)


func _handle_debug_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_change_mouse_mode"):
		_debug_change_mouse_mode()
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


#region Debug
func _debug_change_mouse_mode() -> void:
	match Input.mouse_mode:
		Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#endregion
