class_name PlayerFlashlightRotation
extends PlayerComponent
## Handles all actions relating to rotating the player's flashlight.

@export_group("Interpolation")
@export var _camera_follow_lerp_speed: float = 20.0

@export_group("Tweening")
@export var _start_run_settings: TweenSettings
@export var _stop_run_settings: TweenSettings
@export var _start_attract_settings: TweenSettings
@export var _stop_attract_settings: TweenSettings

@export_group("References")
@export var _flashlight_base: Node3D
@export var _offset_node: Node3D
@export var _attract_node: Node3D
@export var _camera: PhantomCamera3D

var _input: InputComponent
var _attract: PlayerFlashlightAttract

var _last_attract_position := Vector3.ZERO
var _has_attract_position := false

var _run_tween: Tween
var _attract_tween: Tween
var _run_weight: float = 0.0
var _attract_weight: float = 0.0

const ROTATION_BOUNDS_X: Vector2 = Vector2(-89, 89)
const RUN_OFFSET_X: float = -50.0


func init() -> void:
	super()
	
	_input = _host.get_component(InputComponent)
	_attract = _host.get_component(PlayerFlashlightAttract)
	
	create_bind(_player.movement_state.changed, _on_player_movement_state_changed)
	create_bind(_attract.interact_attractor_updated, _on_attract_interact_attractor_updated)


func tick(delta: float) -> void:
	_base_follow_camera(delta)
	
	_apply_run_offset()
	_apply_attract_offset()
	
	# Clamp X to not overshoot
	_flashlight_base.global_rotation.x = deg_to_rad(clampf(_flashlight_base.global_rotation_degrees.x, ROTATION_BOUNDS_X.x, ROTATION_BOUNDS_X.y))


func _base_follow_camera(delta: float) -> void:
	var target: Node3D = _camera
	
	var current_quat := _flashlight_base.global_transform.basis.get_rotation_quaternion()
	var target_quat := target.global_transform.basis.get_rotation_quaternion()
	
	var interp := current_quat.slerp(target_quat, Shortcuts.get_lerp_delta(_camera_follow_lerp_speed, delta))
	
	_flashlight_base.global_transform.basis = Basis(interp)


func _apply_run_offset() -> void:
	# Clamp base X first so the offset node blends from the clamped value
	_flashlight_base.global_rotation.x = deg_to_rad(clampf(
		_flashlight_base.global_rotation_degrees.x,
		ROTATION_BOUNDS_X.x,
		ROTATION_BOUNDS_X.y
	))
	
	var base_x := _flashlight_base.global_rotation.x
	var run_x := deg_to_rad(RUN_OFFSET_X)
	
	# weight 0 = follows base X, weight 1 = run offset X
	_offset_node.global_rotation.x = lerpf(base_x, run_x, _run_weight)


func _apply_attract_offset() -> void:
	# blend from run offset rotation so running + attracting stack correctly
	var from_basis := _offset_node.global_basis.orthonormalized()
	
	var attract = _attract.get_attraction_position()
	if attract != null:
		_last_attract_position = attract
		_has_attract_position = true
	
	if not _has_attract_position or is_zero_approx(_attract_weight):
		_attract_node.global_basis = from_basis
		return
	
	var to_target := _last_attract_position - _attract_node.global_position
	# fails on zero-length or straight up/down since looking_at() won't work
	if to_target.length_squared() < 0.0001 or absf(to_target.normalized().dot(Vector3.UP)) > 0.999:
		_attract_node.global_basis = from_basis
		return
	
	var target_basis := Basis.looking_at(to_target.normalized(), Vector3.UP)
	var q := from_basis.get_rotation_quaternion().slerp(target_basis.get_rotation_quaternion(), _attract_weight)
	_attract_node.global_basis = Basis(q)


func _tween_run_weight(target: float, settings: TweenSettings) -> void:
	if _run_tween:
		_run_tween.kill()
	
	var distance := absf(target - _run_weight)
	if is_zero_approx(distance):
		return
	
	_run_tween = create_tween()
	_run_tween.tween_property(self, "_run_weight", target, settings.time * distance)\
		.set_ease(settings.ease).set_trans(settings.trans)


func _tween_attraction_weight(target: float, settings: TweenSettings) -> void:
	if _attract_tween:
		_attract_tween.kill()
	
	var distance := absf(target - _attract_weight)
	if is_zero_approx(distance):
		return
	
	_attract_tween = create_tween()
	_attract_tween.tween_property(self, "_attract_weight", target, settings.time * distance)\
		.set_ease(settings.ease).set_trans(settings.trans)


func _on_player_movement_state_changed(from: int, to: int) -> void:
	if from == PlayerMovement.MovementState.RUNNING:
		_tween_run_weight(0.0, _stop_run_settings)
	elif to == PlayerMovement.MovementState.RUNNING:
		_tween_run_weight(1.0, _start_run_settings)


func _on_attract_interact_attractor_updated(new: Node3D) -> void:
	if new != null:
		_tween_attraction_weight(1.0, _start_attract_settings)
	else:
		_tween_attraction_weight(0.0, _stop_attract_settings)
