class_name GravityComponent
extends Component
## Generic Component that applies gravity to a CharacterBody3D.
##
## Attach to any component that supports GenericComponents to tie it to that components active states.
## Can be used on Player, Enemy3D, etc.

var target: CharacterBody3D


func init() -> void:
	if host.node is not CharacterBody3D:
		push_error("GravityComponent must be assigned to CharacterBody3D!")
		queue_free()
	
	target = host.node


func physics_tick(_delta: float) -> void:
	target.velocity += target.get_gravity()
