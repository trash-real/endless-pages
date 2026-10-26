# NOTE
# This shares a decent amount of data with PlayerAmbientLight.
# Could be a good idea to make a PlayerLightComponent class that these inherit from.
# Not really an issue with just these two classes, but the structure would be great
# if I want to go for different light types.

class_name PlayerFlashlightSpotLight
extends PlayerComponent
## Handles the visibility of the player's flashlight's [SpotLight3D].

@export_group("References")
@export var _light: SpotLight3D


func init() -> void:
	super()
	
	_apply_stats()
	
	_check_if_initially_active()


## Turn on.
func activate() -> void:
	_light.visible = true


## Turn off.
func deactivate() -> void:
	_light.visible = false


## Applies light related stats from PlayerStats resource.
func _apply_stats() -> void:
	_light.spot_range = _player.stats.light_range
	_light.spot_angle = _player.stats.light_angle
	_light.light_energy = _player.stats.light_power


func _check_if_initially_active() -> void:
	if _player.light_state.get_state() == PlayerFlashlightController.LightState.ON:
		activate()
	else:
		deactivate()
