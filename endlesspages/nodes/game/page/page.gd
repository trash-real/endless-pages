class_name Page
extends Node3D

signal taken(page: Page)

@export_group("References")
@export var _interactible: InteractibleComponent


func _ready() -> void:
	_interactible.interacted.connect(_on_interactible_interacted)


func generate(data: PageData = null) -> void:
	if not data:
		data = PageData.new()
	
	set_enabled(true)


func take_page() -> void:
	set_enabled(false)
	
	taken.emit(self)


func set_enabled(enabled: bool = true) -> void:
	visible = enabled
	_interactible.set_enabled(enabled)


func _on_interactible_interacted() -> void:
	take_page()
