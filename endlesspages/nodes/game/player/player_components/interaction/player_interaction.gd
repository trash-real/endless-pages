class_name PlayerInteraction
extends PlayerComponent
## Handles interacting with objects that have an [InteractibleComponent] attached.

signal interacted(with: InteractibleComponent)
signal target_changed(new: InteractibleComponent)

@export var interact_cast: ShapeCast3D

var _input: InputComponent
var _target: InteractibleComponent = null


func init() -> void:
	super()
	
	_input = _host.get_component(InputComponent)
	
	create_bind(_input.interacted, _on_input_interacted)


func tick(_delta: float) -> void:
	var target := _find_target()
	
	if target != _target:
		_set_target(target)


func deactivate() -> void:
	_set_target(null)


func _find_target() -> InteractibleComponent:
	if not interact_cast.is_colliding():
		return null
	
	for i in interact_cast.get_collision_count():
		var obj: Object = interact_cast.get_collider(i)
		if not is_instance_valid(obj):
			continue
		var node := obj as Node
		if node == null or _is_dying(node):
			continue
		var parent := node.get_parent()
		if parent is InteractibleComponent:
			return parent
	
	return null


func _set_target(new: InteractibleComponent) -> void:
	if is_instance_valid(_target):
		_target.set_targeted(false)
		if _target.tree_exiting.is_connected(_on_target_exiting):
			_target.tree_exiting.disconnect(_on_target_exiting)

	_target = new

	if _target:
		_target.set_targeted(true)
		_target.tree_exiting.connect(_on_target_exiting)

	target_changed.emit(_target)


func _on_target_exiting() -> void:
	if is_instance_valid(_target) and _target.tree_exiting.is_connected(_on_target_exiting):
		_target.tree_exiting.disconnect(_on_target_exiting)
	_target = null
	target_changed.emit(null)


func _on_input_interacted() -> void:
	if not is_instance_valid(_target):
		return
	var target := _target
	interacted.emit(target)
	target.interact()


func _is_dying(node: Node) -> bool:
	while node:
		if node.is_queued_for_deletion():
			return true
		node = node.get_parent()
	return false
