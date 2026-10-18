class_name Shortcuts
extends Node


static func get_lerp_delta(speed: float, delta: float) -> float:
	return 1.0 - exp(-speed * delta)


static func recreate_tween(tween: Tween, caller: Node) -> Tween:
	if tween:
		tween.kill()
	return caller.create_tween()
