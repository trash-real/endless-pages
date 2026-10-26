class_name PlayerFlashlightController
extends PlayerComponent
## Handles all input related to controlling the flashlight.
##
## Communicates these changes to other components with the LightState state machine.

enum LightState {
	ON,
	OFF,
}

var _input: InputComponent


func init() -> void:
	super()
	
	_input = _host.get_component(InputComponent)
	
	create_bind(_input.light_pressed, _on_input_light_pressed)
	create_bind(_input.light_released, _on_input_light_released)


## Player has pressed the flashlight's on/off button.
func _light_pressed() -> void:
	pass


## Player has released the flashlight's on/off button.
func _light_released() -> void:
	_set_light_state(_get_toggled_light_state())


func _set_light_state(new: LightState) -> void:
	_player.light_state.request(new)


func _get_toggled_light_state() -> LightState:
	if _player.light_state.get_state() == LightState.OFF:
		return LightState.ON
	else:
		return LightState.OFF


func _on_input_light_pressed() -> void:
	_light_pressed()


func _on_input_light_released() -> void:
	_light_released()
