extends Node3D

signal taken

@export_group("References")
@export var _interactible: InteractibleComponent


func _ready() -> void:
	_interactible.interacted.connect(_on_interactible_interacted)


func take_page() -> void:
	taken.emit()
	
	visible = false
	_interactible.set_enabled(false)
	
	await get_tree().create_timer(3.0).timeout
	
	visible = true
	_interactible.set_enabled(true)


func _on_interactible_interacted() -> void:
	take_page()
