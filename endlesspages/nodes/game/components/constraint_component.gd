class_name ConstraintComponent
extends Component
## Applies a constraint while the component is active.

@export var types: Array[Constraint.Type] = []


func activate() -> void:
	for type in types:
		Constraints.add(type, host.node)
		print("Added constraint")


func deactivate() -> void:
	for type in types:
		Constraints.remove(type, host.node)
		print("Removed constraint")


## Precaution in case deactivate doesn't happen.
func _exit_tree() -> void:
	if host != null:
		Constraints.remove_all(host.node)
