class_name PlayerInputComponent
extends Component

signal run_pressed
signal run_released
signal light_toggled
signal interacted


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_run"):
		run_pressed.emit()
	elif event.is_action_released("player_run"):
		run_released.emit()
	
	if event.is_action_pressed("player_toggle_light"):
		light_toggled.emit()
	
	if event.is_action_pressed("player_interact"):
		interacted.emit()


func get_movement_direction() -> Vector2:
	if not enabled:
		return Vector2.ZERO
	
	return Input.get_vector(
		"player_move_left", "player_move_right",
		"player_move_forward", "player_move_backward"
		)


func is_running() -> bool:
	return Input.is_action_pressed("player_run")
