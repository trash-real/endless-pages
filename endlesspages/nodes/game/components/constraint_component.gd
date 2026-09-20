class_name ConstraintComponent
extends Component
## Applies a constraint while the component is active.

@export var types: Array[Constraint.Type] = []


func activate() -> void:
	for type in types:
		Constraints.add(type, _host.node)


func deactivate() -> void:
	for type in types:
		Constraints.remove(type, _host.node)


## Precaution in case deactivate doesn't happen.
func _exit_tree() -> void:
	if _host != null:
		Constraints.remove_all(_host.node)
