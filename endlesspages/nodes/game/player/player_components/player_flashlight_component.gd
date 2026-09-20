class_name PlayerFlashlightRotationComponent
extends PlayerComponent
## Handles all actions relating to rotating the player's flashlight.

@export_group("Interpolation")
@export var _camera_follow_lerp_speed: float = 20.0

@export_group("Tweening")
@export var _run_settings: TweenSettings

@export_group("References")
@export var _flashlight_base: Node3D
@export var _run_offset_node: Node3D
@export var _camera: PhantomCamera3D

var _input: InputComponent
var _attractor: Node3D = null # TODO: Replace type with a FlashlightAttractionArea :)

var _run_tween: Tween
var _run_weight: float = 0.0

const ROTATION_BOUNDS_X: Vector2 = Vector2(-89, 89)
const RUN_OFFSET_X: float = -45.0
const RUN_WEIGHT_MIN: float = -0.1  # small dip allowed
const RUN_WEIGHT_MAX: float = 1.15  # small overshoot allowed


func init() -> void:
	super()
	
	_input = _host.get_component(InputComponent)
	
	create_bind(_player.movement_state.changed, _on_player_movement_state_changed)


func tick(delta: float) -> void:
	_follow_camera(delta)
	_run_offset_node.rotation.x = deg_to_rad(RUN_OFFSET_X) * clampf(_run_weight, RUN_WEIGHT_MIN, RUN_WEIGHT_MAX)
	
	# Clamp X to not overshoot
	_flashlight_base.global_rotation.x = deg_to_rad(clampf(_flashlight_base.global_rotation_degrees.x, ROTATION_BOUNDS_X.x, ROTATION_BOUNDS_X.y))


func _follow_camera(delta: float) -> void:
	var target: Node3D = _camera
	
	var current_quat := _flashlight_base.global_transform.basis.get_rotation_quaternion()
	var target_quat := target.global_transform.basis.get_rotation_quaternion()
	
	var interp := current_quat.slerp(target_quat, _get_lerp_delta(_camera_follow_lerp_speed, delta))
	
	_flashlight_base.global_transform.basis = Basis(interp)


func _get_offset_rotation_target() -> Vector3:
	if _player.movement_state.get_state() == PlayerMovementComponent.MovementState.RUNNING:
		return Vector3(deg_to_rad(RUN_OFFSET_X), _camera.global_rotation.y, 0.0)
	return _camera.global_rotation


func _tween_run_weight(target: float) -> void:
	if _run_tween:
		_run_tween.kill()
	
	var distance := absf(target - _run_weight)
	if is_zero_approx(distance):
		return
	
	_run_tween = create_tween()
	_run_tween.tween_property(self, "_run_weight", target, _run_settings.time * distance)\
		.set_ease(_run_settings.ease).set_trans(_run_settings.trans)


func _on_player_movement_state_changed(from: int, to: int) -> void:
	if from == PlayerMovementComponent.MovementState.RUNNING:
		_tween_run_weight(0.0)
	elif to == PlayerMovementComponent.MovementState.RUNNING:
		_tween_run_weight(1.0)


func _get_lerp_delta(speed: float, delta: float) -> float:
	return 1.0 - exp(-speed * delta)
