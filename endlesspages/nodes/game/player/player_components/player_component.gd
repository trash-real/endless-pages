@abstract
class_name PlayerComponent
extends Component
## A [Component] specific to the [Player].
##
## Handles restricting state activity by checking Player specific states/constraints.

## Constraints that switch this component off while held. Empty means never.
@export var blocked_by: Array[Constraint.Type] = []

## Move states which this component is active during. Empty means always active.
@export var active_move_states: Array[PlayerMovement.MovementState]
 
var _player: Player
 
 
func init() -> void:
	_player = _host.node as Player
	assert(_player != null, "PlayerComponent requires a Player host.")
 
 
func _is_active() -> bool:
	if not super():
		return false
	# There are specified active move states and the current state is not in it.
	if not active_move_states.is_empty() and not _player.movement_state.get_state() in active_move_states:
		return false
	return not Constraints.has_any(blocked_by)
