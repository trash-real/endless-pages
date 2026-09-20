class_name PlayerFlashlightRotationComponent
extends PlayerComponent
## Handles all actions relating to rotating the player's flashlight.

@export_group("Interpolation")
@export var _lerp_speed: float = 10.0

@export_group("Mouse Offset", "_mouse_offset")
@export var _mouse_offset_lerp_speed: float = 15.0
@export var _mouse_offset_dampener: float = 100.0

@export_group("References")
@export var _flashlight_base: Node3D
@export var _camera: PhantomCamera3D

var _input: InputComponent

var _target_rotation: Vector3
var _attractor: Node3D = null # TODO: Replace type with a FlashlightAttractorComponent :)

var _mouse_movement_offset: Vector2 = Vector2(0.0, 0.0)

const ROTATION_BOUNDS_X: Vector2 = Vector2(-89, 89)
const MOUSE_OFFSET_BOUNDS_X: Vector2 = Vector2(-20, 20)
const MOUSE_OFFSET_BOUNDS_Y: Vector2 = Vector2(-12, 12)
const RUN_OFFSET_X: float = -45.0


func init() -> void:
	super()
	
	_input = host.get_component(InputComponent)
	
	_input.mouse_motion.connect(_on_input_mouse_motion)


func tick(delta: float) -> void:
	_target_rotation = _get_rotation_target()
	_flashlight_base.global_rotation.x = lerp_angle(_flashlight_base.global_rotation.x, _target_rotation.x, _lerp_speed * delta)
	_flashlight_base.global_rotation.y = lerp_angle(_flashlight_base.global_rotation.y, _target_rotation.y, _lerp_speed * delta)
	
	# Clamp X to not overshoot
	_flashlight_base.global_rotation.x = deg_to_rad(clampf(_flashlight_base.global_rotation_degrees.x, ROTATION_BOUNDS_X.x, ROTATION_BOUNDS_X.y))
	
	# Add mouse movement offset to rotation
	_flashlight_base.global_rotation += Vector3(deg_to_rad(-_mouse_movement_offset.y), deg_to_rad(-_mouse_movement_offset.x), 0.0)
	
	# Lerp mouse offset to zero
	_mouse_movement_offset = _mouse_movement_offset.lerp(Vector2.ZERO, _mouse_offset_lerp_speed * delta)


func _follow_camera() -> void:
	_target_rotation = _camera.global_rotation
	_flashlight_base.global_rotation = _target_rotation
	
	# Add mouse movement offset to rotation
	_flashlight_base.global_rotation += Vector3(deg_to_rad(-_mouse_movement_offset.y), deg_to_rad(-_mouse_movement_offset.x), 0.0)


func _get_rotation_target() -> Vector3:
	if _player.movement_state.get_state() == PlayerMovementComponent.MovementState.RUNNING:
		return Vector3(RUN_OFFSET_X, _camera.global_rotation.y, 0.0)
	return _camera.global_rotation


func _rotate_to_target(target: Vector3, delta: float) -> Vector3:
	var x := lerp_angle(_target_rotation.x, target.x, _lerp_speed * delta)
	var y := lerp_angle(_target_rotation.y, target.y, _lerp_speed * delta)
	
	return Vector3(x, y, 0.0)


func _on_input_mouse_motion(relative: Vector2) -> void:
	_mouse_movement_offset += relative / _mouse_offset_dampener
	_mouse_movement_offset.x = clampf(_mouse_movement_offset.x, MOUSE_OFFSET_BOUNDS_X.x, MOUSE_OFFSET_BOUNDS_X.y)
	_mouse_movement_offset.y = clampf(_mouse_movement_offset.y, MOUSE_OFFSET_BOUNDS_Y.x, MOUSE_OFFSET_BOUNDS_Y.y)
