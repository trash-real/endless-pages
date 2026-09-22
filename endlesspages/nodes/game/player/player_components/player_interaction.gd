class_name PlayerInteraction
extends PlayerComponent
## Handles interacting with objects that have an [InteractibleComponent] attached.

signal interacted(with: InteractibleComponent)
signal target_changed(new: InteractibleComponent)

@export var interact_cast: ShapeCast3D

var _target: InteractibleComponent


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
		var node := interact_cast.get_collider(0)
		if node is InteractibleComponent:
			return node
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
