extends Node
## Set of constraints applied to the player by enemies, cutscenes, items, etc.[br][br]
## Autoloaded as [code]Constraints[/code].
##
## Counted by holder. A holder is typically the node that gives the constraint.

signal changed

var _holders: Dictionary = {} # Constraint.Type: Array[Object]


func add(type: Constraint.Type, holder: Object) -> void:
	var list: Array = _holders.get_or_add(type, [])
	if holder not in list:
		list.append(holder)
		changed.emit()


func remove(type: Constraint.Type, holder: Object) -> void:
	var list: Array = _holders.get(type, [])
	if holder in list:
		list.erase(holder)
		changed.emit()


func has(type: Constraint.Type) -> bool:
	return not _holders.get(type, []).is_empty()


## has for multiple types
func has_any(types: Array) -> bool:
	for type in types:
		if has(type):
			return true
	return false


## Releases all restrictions held by a specific object.[br]
## If a component applies a restriction, always call this during deactivation.
func remove_all(holder: Object) -> void:
	var change: bool = false
	for type in _holders:
		var list: Array = _holders[type]
		if holder in list:
			list.erase(holder)
			change = true
	if change:
		changed.emit()


## Clears all restrictions. Mainly for end of round.
func clear() -> void:
	if _holders.is_empty():
		return
	_holders.clear()
	changed.emit()
