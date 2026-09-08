class_name Constraint
extends RefCounted
## Enum holder

enum Type {
	CAMERA_LOCKED,   ## Camera cannot be turned.
	MOVEMENT_LOCKED, ## Player cannot move.
	LIGHT_LOCKED,    ## Flashlight cannot be toggled.
	RADAR_LOCKED,    ## Radar cannot be taken out/put away.
	INPUT_CAPTURED,  ## All input is disabled.
	
	WORLD_FROZEN,    ## Granny minigame...
}
