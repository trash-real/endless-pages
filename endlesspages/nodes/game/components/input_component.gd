class_name InputComponent
extends Component
## Tracks user input. 
##
## Fires signals for player action triggers and has methods for getting state of other actions.

signal light_pressed
signal light_released
signal interact_pressed
signal interact_released
signal mouse_motion(relative: Vector2)

var _triggers: Dictionary[String, Array] = {
	"player_toggle_light": [light_pressed, light_released],
	"player_interact": [interact_pressed, interact_released],
}


#region Input
func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build():
		_handle_debug_input(event)
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if not enabled:
		return
	
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_motion.emit(event.relative)
		return
	
	for action: StringName in _triggers:
		if event.is_action_pressed(action):
			_triggers[action][0].emit()
		elif event.is_action_released(action):
			_triggers[action][1].emit()


func _handle_debug_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_change_mouse_mode"):
		_debug_change_mouse_mode()
#endregion


#region Helpers
func get_movement_direction() -> Vector3:
	if not enabled:
		return Vector3.ZERO
	
	var dir := Input.get_vector(
		"player_move_left", "player_move_right",
		"player_move_backward", "player_move_forward"
		)
	
	return Vector3(dir.x, 0.0, dir.y)


func is_running() -> bool:
	return enabled and Input.is_action_pressed("player_run")
#endregion


#region Debug
func _debug_change_mouse_mode() -> void:
	match Input.mouse_mode:
		Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#endregion
