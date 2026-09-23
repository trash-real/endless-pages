class_name PlayerInteraction
extends PlayerComponent
## Handles interacting with objects that have an [InteractibleComponent] attached.

signal interacted(with: InteractibleComponent)
signal target_changed(new: InteractibleComponent)

@export var interact_cast: ShapeCast3D

var _target: InteractibleComponent = null


func tick(_delta: float) -> void:
	var target := _find_target()
	
	if target != _target:
		_update_target(target)


func deactivate() -> void:
	if _target:
		_target.set_targeted(false)
	
	_target = null
	target_changed.emit(null)


func _find_target() -> InteractibleComponent:
	if interact_cast.is_colliding():
		var node: Node = interact_cast.get_collider(0)
		var parent := node.get_parent()
		if parent is InteractibleComponent:
			return parent
	return null


func _update_target(new: InteractibleComponent) -> void:
	if _target:
		_target.set_targeted(false)
	
	if new != null:
		_target = new
		new.set_targeted(true)
		target_changed.emit(new)
	else:
		_target = null
		target_changed.emit(null)
