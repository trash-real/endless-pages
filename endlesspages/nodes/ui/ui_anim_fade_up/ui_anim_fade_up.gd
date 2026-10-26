class_name UIFadeUpAnimator
extends Control

@export_group("Start")
@export var _start_position: Vector2
@export var _start_scale: Vector2 = Vector2.ONE
@export var _start_color: Color = Color(1.0, 1.0, 1.0, 0.0)
@export_group("End")
@export var _end_position: Vector2
@export var _end_scale: Vector2 = Vector2.ONE
@export var _end_color: Color = Color.WHITE
@export_group("Tweening")
@export var _fade_in_tween_settings: TweenSettings = TweenSettings.new()
@export var _fade_out_tween_settings: TweenSettings = TweenSettings.new()
@export_group("Settings")
@export var _use_offset_transform: bool = true

var _position: Vector2:
	set(value):
		_position = value
		_set_pos(value)
var _scale: Vector2:
	set(value):
		_scale = value
		_set_scale(value)
var _color: Color:
	set(value):
		_color = value
		modulate = _color

var _tween: Tween


func _ready() -> void:
	if _use_offset_transform:
		offset_transform_enabled = true
	
	_set_to_start()


func fade_in(settings: TweenSettings = null) -> Tween:
	if not settings:
		settings = _fade_in_tween_settings
	
	_tween = _recreate_tween().set_parallel()
	
	_set_to_start()
	
	_tween.tween_property(self, "_position", _end_position, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
	_tween.tween_property(self, "_scale", _end_scale, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
	_tween.tween_property(self, "_color", _end_color, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
	
	return _tween


func fade_out(settings: TweenSettings = null) -> Tween:
	if not settings:
		settings = _fade_out_tween_settings
	
	_tween = _recreate_tween().set_parallel()
	
	_set_to_end()
	
	_tween.tween_property(self, "_position", _start_position, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
	_tween.tween_property(self, "_scale", _start_scale, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
	_tween.tween_property(self, "_color", _start_color, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
	
	return _tween


func _set_to_start() -> void:
	_position = _start_position
	_scale = _start_scale
	_color = _start_color


func _set_to_end() -> void:
	_position = _end_position
	_scale = _end_scale
	_color = _end_color


func _set_pos(new: Vector2) -> void:
	if _use_offset_transform:
		offset_transform_position = new
	else:
		position = new


func _set_scale(new: Vector2) -> void:
	if _use_offset_transform:
		offset_transform_scale = new
	else:
		scale = new


func _recreate_tween() -> Tween:
	if _tween:
		_tween.kill()
	return create_tween()
