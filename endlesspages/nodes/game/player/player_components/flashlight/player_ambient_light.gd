class_name PlayerAmbientLight
extends PlayerComponent
## Handles the player's ambient light that is around them while their flashlight is off.

@export_group("Tween Settings", "_ts")
@export var _ts_activate: TweenSettings
@export var _ts_deactivate: TweenSettings
@export_group("References")
@export var _light: OmniLight3D

var _range: float:
	set(value):
		_range = value
		_light.omni_range = value
var _energy: float:
	set(value):
		_energy = value
		_light.light_energy = value

var _range_tween: Tween


func init() -> void:
	super()
	
	_apply_stats()
	
	_check_if_initially_active()


## Turn on.
func activate() -> void:
	_tween_range(_player.stats.amblight_range, _ts_activate)


## Turn off.
func deactivate() -> void:
	_tween_range(0.0, _ts_deactivate)


## Applies light related stats from PlayerStats resource.
func _apply_stats() -> void:
	_range = 0.0 # Starts off
	_energy = _player.stats.amblight_power


func _check_if_initially_active() -> void:
	if _player.light_state.get_state() == PlayerFlashlightController.LightState.OFF:
		activate()
	else:
		deactivate()


func _tween_range(value: float, settings: TweenSettings) -> void:
	_range_tween = Shortcuts.recreate_tween(_range_tween, self)
	_range_tween.tween_property(_light, "omni_range", value, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
