class_name Shortcuts
extends Node


static func get_lerp_delta(speed: float, delta: float) -> float:
	return 1.0 - exp(-speed * delta)


static func recreate_tween(tween: Tween, caller: Node) -> Tween:
	if tween:
		tween.kill()
	return caller.create_tween()


static func tween_property_using_settings(
	tween: Tween, target: Variant, property: String,
	end_value: Variant, settings: TweenSettings
):
	tween.tween_property(target, property, end_value, settings.time)\
		.set_ease(settings.ease).set_trans(settings.trans)


static func apply_tween_settings(tween: Tween, settings: TweenSettings) -> void:
	tween.set_ease(settings.ease).set_trans(settings.trans)
