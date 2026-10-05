class_name PositionTweenSettingsUI
extends TweenSettings

@export var final_value: Vector2

@export var global: bool = false
@export var offset_transform: bool = false


func perform_tween(tween: Tween, target: Node) -> Tween:
	var property := "global_position" if global else "position"
	if offset_transform:
		property = "offset_transform_position"
	
	tween.tween_property(target, property, final_value, time)\
		.set_ease(ease).set_trans(trans)
	return tween
