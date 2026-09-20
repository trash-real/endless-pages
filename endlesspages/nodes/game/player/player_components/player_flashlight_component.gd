class_name PlayerFlashlightRotationComponent
extends PlayerComponent
## Handles all actions relating to rotating the player's flashlight.

@export_group("Interpolation")
@export var _camera_follow_lerp_speed: float = 20.0

@export_group("Tweening")
@export var _start_run_settings: TweenSettings
@export var _stop_run_settings: TweenSettings

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
	_base_follow_camera(delta)
	
	_apply_run_offset()
	
	# Clamp X to not overshoot
	_flashlight_base.global_rotation.x = deg_to_rad(clampf(_flashlight_base.global_rotation_degrees.x, ROTATION_BOUNDS_X.x, ROTATION_BOUNDS_X.y))


func _base_follow_camera(delta: float) -> void:
	var target: Node3D = _camera
	
	var current_quat := _flashlight_base.global_transform.basis.get_rotation_quaternion()
	var target_quat := target.global_transform.basis.get_rotation_quaternion()
	
	var interp := current_quat.slerp(target_quat, _get_lerp_delta(_camera_follow_lerp_speed, delta))
	
	_flashlight_base.global_transform.basis = Basis(interp)


func _apply_run_offset() -> void:
	# Clamp base X first so the offset node blends from the clamped value
	_flashlight_base.global_rotation.x = deg_to_rad(clampf(
		_flashlight_base.global_rotation_degrees.x,
		ROTATION_BOUNDS_X.x,
		ROTATION_BOUNDS_X.y
	))
	
	var weight := clampf(_run_weight, RUN_WEIGHT_MIN, RUN_WEIGHT_MAX)
	var base_x := _flashlight_base.global_rotation.x
	var run_x := deg_to_rad(RUN_OFFSET_X)
	
	# weight 0 = follows base X, weight 1 = run offset X
	_run_offset_node.global_rotation.x = lerpf(base_x, run_x, weight)


func _tween_run_weight(target: float, settings: TweenSettings) -> void:
	if _run_tween:
		_run_tween.kill()
	
	var distance := absf(target - _run_weight)
	if is_zero_approx(distance):
		return
	
	_run_tween = create_tween()
	_run_tween.tween_property(self, "_run_weight", target, settings.time * distance)\
		.set_ease(settings.ease).set_trans(settings.trans)


func _on_player_movement_state_changed(from: int, to: int) -> void:
	if from == PlayerMovementComponent.MovementState.RUNNING:
		_tween_run_weight(0.0, _stop_run_settings)
	elif to == PlayerMovementComponent.MovementState.RUNNING:
		_tween_run_weight(1.0, _start_run_settings)


func _get_lerp_delta(speed: float, delta: float) -> float:
	return 1.0 - exp(-speed * delta)
