class_name PlayerCameraComponent
extends PlayerComponent
## Handles the player camera's rotation.

@export var _sensitivity: float = 0.005 # TODO: Move to Settings

@export_group("References")
@export var _camera_y: Node3D
@export var _camera_x: Node3D
@export var _camera: PhantomCamera3D

var _input: InputComponent


func init() -> void:
	super()
	_input = _player.components.get_component(InputComponent)
	
	_input.mouse_motion.connect(_on_input_mouse_motion)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_input_mouse_motion(relative: Vector2) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	_camera_y.rotate_y(-relative.x * _sensitivity)
	_camera_x.rotate_x(-relative.y * _sensitivity)
	
	# Clamp vertical rotation
	_camera_x.rotation.x = clamp(_camera_x.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func get_forward_vector() -> Vector3:
	return -_camera.global_basis.z


func get_right_vector() -> Vector3:
	return _camera.global_basis.x
