class_name PlayerCameraBobbing
extends PlayerComponent
## Handles the bobbing of the player camera while moving.
##
## Juice effect.

@export_group("Base")
@export var _base_position: Vector3 = Vector3(0.0, 0.0, 0.0)

@export_group("X Bobbing")
@export var _x_amplitude: float = 0.03
@export var _x_frequency: float = 1.0
@export var _x_wave_offset: float = 0.0
@export var _x_abs: bool = false

@export_group("Y Bobbing")
@export var _y_amplitude: float = 0.05
@export var _y_frequency: float = 1.0
@export var _y_wave_offset: float = 1.5
@export var _y_abs: bool = true

@export_group("Tuning")
@export var _max_speed: float = 6.0
@export var _base_step_rate: float = 1.6
@export var _blend_speed: float = 10.0

@export_group("References")
@export var _camera_base: Node3D

var _x_phase: float
var _y_phase: float
var _intensity: float


func tick(delta: float) -> void:
	var horizontal_speed := Vector2(_player.velocity.x, _player.velocity.z).length()
	var grounded := _player.is_on_floor()

	var target := clampf(horizontal_speed / _max_speed, 0.0, 1.0) if grounded else 0.0
	_intensity = lerpf(_intensity, target, 1.0 - exp(-_blend_speed * delta))

	if target == 0.0 and _intensity < 0.001:
		_intensity = 0.0
		_x_phase = 0.0
		_y_phase = 0.0
	elif grounded:
		var advance := horizontal_speed * _base_step_rate * delta
		_x_phase = fmod(_x_phase + advance * _x_frequency, TAU)
		_y_phase = fmod(_y_phase + advance * _y_frequency, TAU)
	
	_camera_base.position = _get_offset()


func _get_offset() -> Vector3:
	var x := sin(_x_phase + _x_wave_offset)
	var y := sin(_y_phase + _y_wave_offset)

	if _x_abs:
		x = absf(x)
	if _y_abs:
		y = absf(y)

	var bob := Vector3(x * _x_amplitude, y * _y_amplitude, 0.0) * _intensity
	return _base_position + bob
