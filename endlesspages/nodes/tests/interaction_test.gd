extends Node

@export var _interactible: InteractibleComponent


func _ready() -> void:
	if not _interactible:
		_interactible = find_child("InteractibleComponent")
	
	_interactible.interacted.connect(_on_interactible_component_interact)


func _on_interactible_component_interact() -> void:
	queue_free()
