class_name PlayerFlashlightRotationComponent
extends PlayerComponent
## Handles all actions relating to rotating the player's flashlight.

@export_group("Interpolation")
@export var _speed: float = 20.0

@export_group("References")
@export var _flashlight_base: Node3D
@export var _camera: PhantomCamera3D

const BOUNDS_X: Vector2 = Vector2(-89, 89)


func init() -> void:
	super()


func tick(delta: float) -> void:
	_flashlight_base.global_rotation = _rotate_to_target(_get_rotation_target(), delta)
	_flashlight_base.global_rotation.x = deg_to_rad(clampf(_flashlight_base.global_rotation_degrees.x, BOUNDS_X.x, BOUNDS_X.y))
	print(_flashlight_base.rotation)


func _get_rotation_target() -> Vector3:
	# Check for flashlight attractors
	return _camera.global_rotation


func _rotate_to_target(target: Vector3, delta: float) -> Vector3:
	var x := lerp_angle(_flashlight_base.global_rotation.x, target.x, _speed * delta)
	var y := lerp_angle(_flashlight_base.global_rotation.y, target.y, _speed * delta)
	
	return Vector3(x, y, 0.0)
