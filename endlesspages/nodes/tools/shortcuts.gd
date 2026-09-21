class_name Shortcuts
extends Node


static func get_lerp_delta(speed: float, delta: float) -> float:
	return 1.0 - exp(-speed * delta)
