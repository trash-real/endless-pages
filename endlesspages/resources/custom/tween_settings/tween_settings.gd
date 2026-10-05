class_name TweenSettings
extends Resource
## Easier way to store Tween related settings.
##
## Things like time, easing, transition.

@export var time: float = 0.5
@warning_ignore("shadowed_global_identifier")
@export var ease: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_QUART


@warning_ignore("unused_parameter")
func perform_tween(tween: Tween, target: Node) -> Tween:
	return null
