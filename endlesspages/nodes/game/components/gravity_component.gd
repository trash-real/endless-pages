class_name GravityComponent
extends Component
## Component that applies gravity to a CharacterBody3D.
##
## Attach to anything with a state machine to tie it to that Node's active states.[br]
## Can be used on [Player], Enemy3D, etc.

var _target: CharacterBody3D


func init() -> void:
	if _host.node is not CharacterBody3D:
		push_error("GravityComponent must be assigned to CharacterBody3D!")
		queue_free()
		return
	
	_target = _host.node


func physics_tick(delta: float) -> void:
	if not _target.is_on_floor():
		_target.velocity += _target.get_gravity() * delta
