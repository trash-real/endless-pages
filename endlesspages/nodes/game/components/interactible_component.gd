class_name InteractibleComponent
extends Node3D
## Tracks interactions from the player.

signal interacted
signal targeted_update(targeted: bool)

@export_multiline var prompt: String = "[LCLICK]\nInteract"


func interact() -> void:
	interacted.emit()


func set_targeted(targeted: bool) -> void:
	targeted_update.emit(targeted)
