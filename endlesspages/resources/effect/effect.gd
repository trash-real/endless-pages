class_name Effect
extends Resource
## Base class of all status effects in the game.
##
## Effects can be added to an EffectComponent which will manage the life cycle of the effects.
## Nodes such as the player can then have components react to this, adjusting stats accordingly.

enum Value {
	NEUTRAL,  ## Not necessarily good or bad.
	POSITIVE, ## Good effect. Something like a speed boost.
	NEGATIVE, ## Bad effect. Something like a speed reduction.
	}

## Is this effect, good, bad, or neither?
@export var value: Value = Value.NEUTRAL

## Leave at 0.0 or lower for unlimited duration.
@export var duration: float = 0.0
