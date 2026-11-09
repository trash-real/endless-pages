class_name PlayerAmbientLight
extends PlayerComponent
## Handles the player's ambient light that is around them while their flashlight is off.

@export_group("References")
@export var _light: OmniLight3D


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
	_light.omni_range = _player.stats.amblight_range
	_light.light_energy = _player.stats.amblight_power


func _check_if_initially_active() -> void:
	if _player.light_state.get_state() == PlayerFlashlightController.LightState.OFF:
		activate()
	else:
		deactivate()
