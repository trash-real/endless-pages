extends CanvasLayer

@export var _open_pos: Vector2 = Vector2.ZERO
@export var _close_pos: Vector2 = Vector2(0.0, 30.0)
@export var _open_settings: TweenSettings
@export var _close_settings: TweenSettings

@export_group("References")
@export var _interaction: PlayerInteraction
@export var _label: RichTextLabel

var _tween: Tween


func _ready() -> void:
	_label.offset_transform_position = _close_pos
	_label.modulate = Color.TRANSPARENT
	
	_interaction.target_changed.connect(_on_interaction_target_changed)


func _on_interaction_target_changed(new: InteractibleComponent) -> void:
	if new == null:
		_do_tween(_close_pos, Color.TRANSPARENT, _close_settings)
		return
	
	_label.text = new.prompt
	_do_tween(_open_pos, Color.WHITE, _open_settings)


func _do_tween(pos: Vector2, mod: Color, settings: TweenSettings) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel()
	_tween.tween_property(_label, "offset_transform_position", pos, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
	_tween.tween_property(_label, "modulate", mod, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)
