class_name InteractibleComponent
extends Node3D
## Tracks interactions from the player.

signal interacted
signal targeted_update(targeted: bool)

@export_multiline var prompt: String = "[LCLICK]\nINTERACT"
@export_multiline var interacted_prompt: String = "INTERACTED.\n"

var _colliders: Array # CollisionShape3D


func _ready() -> void:
	_colliders = find_children("*", "CollisionShape3D") as Array[CollisionShape3D]


func interact() -> void:
	interacted.emit()


func set_targeted(targeted: bool) -> void:
	targeted_update.emit(targeted)


func set_enabled(enabled: bool) -> void:
	for c in _colliders:
		c.set_deferred("disabled", not enabled)
