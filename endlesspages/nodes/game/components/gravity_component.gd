class_name GravityComponent
extends Component
## Component that applies gravity to a CharacterBody3D.
##
## Attach to anything with a state machine to tie it to that Node's active states.[br]
## Can be used on [Player], Enemy3D, etc.

var target: CharacterBody3D


func init() -> void:
	if host.node is not CharacterBody3D:
		push_error("GravityComponent must be assigned to CharacterBody3D!")
		queue_free()
	
	target = host.node


func physics_tick(_delta: float) -> void:
	if not target.is_on_floor():
		target.velocity += target.get_gravity() * _delta
