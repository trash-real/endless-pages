class_name PlayerFlashlightController
extends PlayerComponent
## Handles turning the flashlight on and off.

enum LightState {
	ON,
	OFF,
}

@export_group("References")
@export var _light: SpotLight3D

var _input: InputComponent


func init() -> void:
	super()
	
	_input = _host.get_component(InputComponent)
	
	create_bind(_input.light_pressed, _on_input_light_pressed)
	create_bind(_input.light_released, _on_input_light_released)
	
	_apply_stats()


## Player has pressed the flashlight's on/off button.
func _light_pressed() -> void:
	# Play press sound
	pass


## Player has released the flashlight's on/off button.
func _light_released() -> void:
	# Play release sound
	_light.visible = not _light.visible


func _apply_stats() -> void:
	_light.spot_range = _player.stats.light_range
	_light.spot_angle = _player.stats.light_angle
	_light.light_energy = _player.stats.light_power


func _on_input_light_pressed() -> void:
	_light_pressed()


func _on_input_light_released() -> void:
	_light_released()
