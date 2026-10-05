class_name PlayerCameraBob
extends PlayerComponent
## Handles the bobbing of the player camera while moving.
##
## Juice effect.

@export_group("X Position Bobbing", "_x_")
@export var _x_amplitude: float = 0.04
@export var _x_frequency: float = 1.0
@export var _x_wave_offset: float = 0.0
## Absolute value gives a bouncing effect
@export var _x_abs: bool = false

@export_group("Y Position Bobbing", "_y_")
@export var _y_amplitude: float = 0.1
@export var _y_frequency: float = 1.0
@export var _y_wave_offset: float = 1.5
## Absolute value gives a bouncing effect
@export var _y_abs: bool = true

@export_group("Z Rotation Bobbing", "_z_")
@export var _z_amplitude: float = 0.01
@export var _z_frequency: float = 1.0
@export var _z_wave_offset: float = 0.0
## Absolute value gives a bouncing effect
@export var _z_abs: bool = false

@export_group("Tuning")
## Multiplier for increasing/decreasing intensity via Settings
@export var bob_intensity_multiplier: float = 1.0
## Bob speed will stop increasing beyond this magnitude
@export var _max_speed: float = 6.0
## Higher = faster steps
@export var _base_step_rate: float = 1.0
## How fast the bobbing lerps to the current desired intensity
@export var _blend_speed: float = 10.0

@export_group("References")
@export var _target: Node3D

var _x_phase: float
var _y_phase: float
var _z_phase: float
var _intensity: float


func tick(delta: float) -> void:
	if _base_step_rate <= 0.0:
		return
	
	var horizontal_speed := Vector2(_player.velocity.x, _player.velocity.z).length()
	var grounded := _player.is_on_floor()

	var target := clampf(horizontal_speed / _max_speed, 0.0, 1.0) if grounded else 0.0
	_intensity = lerpf(_intensity, target, 1.0 - exp(-_blend_speed * delta))

	if target == 0.0 and _intensity < 0.001:
		_intensity = 0.0
		_x_phase = 0.0
		_y_phase = 0.0
		_z_phase = 0.0
	elif grounded:
		var advance := horizontal_speed * _base_step_rate * delta
		_x_phase = fmod(_x_phase + advance * _x_frequency, TAU)
		_y_phase = fmod(_y_phase + advance * _y_frequency, TAU)
		_z_phase = fmod(_z_phase + advance * _z_frequency, TAU)
	
	_target.position = _get_pos_offset()
	_target.rotation = _get_rot_offset()


func _get_pos_offset() -> Vector3:
	var x := sin(_x_phase + _x_wave_offset)
	var y := sin(_y_phase + _y_wave_offset)
	
	if _x_abs:
		x = absf(x)
	if _y_abs:
		y = absf(y)
	
	var bob := Vector3(x * _x_amplitude, y * _y_amplitude, 0.0) * _get_intensity()
	return bob


func _get_rot_offset() -> Vector3:
	var z := sin(_z_phase + _z_wave_offset)
	
	if _z_abs:
		z = absf(z)
	
	var bob := Vector3(0.0, 0.0, z * _z_amplitude) * _get_intensity()
	return bob


func _get_intensity() -> float:
	return _intensity * bob_intensity_multiplier
