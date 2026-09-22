class_name InteractibleComponent
extends Node
## Tracks interactions from the player.

signal interacted
signal targeted_update(targeted: bool)

@export var parent: Node


func _ready() -> void:
	if not parent:
		parent = get_parent()


func interact() -> void:
	interacted.emit()


func set_targeted(targeted: bool) -> void:
	targeted_update.emit(targeted)
