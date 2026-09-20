class_name PlayerCameraComponent
extends PlayerComponent
## Handles the player camera's rotation.

@export var _sensitivity: float = 0.003 # TODO: Move to Settings

@export_group("Interpolation")
@export var _lerp_speed: float = 20.0

@export_group("References")
@export var _camera_y: Node3D
@export var _camera_x: Node3D
@export var _camera: PhantomCamera3D

var _input: InputComponent

var _target_rotation: Vector3 = Vector3.ZERO

const ROTATION_BOUNDS_X: Vector2 = Vector2(-70, 70)


func init() -> void:
	super()
	_input = _player.components.get_component(InputComponent)
	
	new_signal(_input.mouse_motion, _on_input_mouse_motion)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func tick(delta: float) -> void:
	_rotate_camera(delta)


func _rotate_camera(delta: float) -> void:
	var x := lerp_angle(_camera_x.rotation.x, _target_rotation.x, _lerp_speed * delta)
	var y := lerp_angle(_camera_y.rotation.y, _target_rotation.y, _lerp_speed * delta)
	
	_camera_x.rotation.x = x
	_camera_y.rotation.y = y


func _on_input_mouse_motion(relative: Vector2) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED or Constraints.has(Constraint.Type.CAMERA_LOCKED):
		return
	
	_target_rotation.y += -relative.x * _sensitivity
	_target_rotation.x += -relative.y * _sensitivity
	
	# Clamp vertical rotation
	_target_rotation.x = clamp(_target_rotation.x, deg_to_rad(ROTATION_BOUNDS_X.x), deg_to_rad(ROTATION_BOUNDS_X.y))


func get_forward_vector() -> Vector3:
	return -_camera.global_basis.z


func get_right_vector() -> Vector3:
	return _camera.global_basis.x
