@abstract
class_name PlayerComponent
extends Component
## A [Component] specific to the [Player].
##
## Handles restricting state activity by checking Player specific states/constraints.

## Which movement states this component runs during. Empty means any.
@export var active_move_states: Array[PlayerMovementComponent.MovementState] = []
 
## Constraints that switch this component off while held. Empty means never.
@export var blocked_by: Array[Constraint.Type] = []
 
var _player: Player
 
 
func init() -> void:
	_player = host.node as Player
	assert(_player != null, "PlayerComponent requires a Player host.")
 
 
func _is_active() -> bool:
	if not super():
		return false
	if not _player.movement_state.is_in(active_move_states):
		return false
	return not Constraints.has_any(blocked_by)
