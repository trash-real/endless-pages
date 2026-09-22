class_name PlayerCameraTilt
extends PlayerComponent
## Tilts camera in movement direction slightly.

@export var _base_tilt: float = 0.6
@export var _max_tilt: float = 5.0
@export var _lerp_speed: float = 10.0

@export_group("References")
@export var _target: Node3D

var _input: InputComponent


func init() -> void:
	super()
	
	_input = _host.get_component(InputComponent)


func tick(delta: float) -> void:
	var tilt := _base_tilt * _input.get_movement_direction().x
	tilt *= Vector2(_player.velocity.x, _player.velocity.z).length()
	tilt = clampf(tilt, -_max_tilt, _max_tilt)
	
	_target.rotation.z = lerp_angle(_target.rotation.z, deg_to_rad(-tilt), Shortcuts.get_lerp_delta(_lerp_speed, delta))
