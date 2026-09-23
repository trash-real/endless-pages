class_name Constraint
extends RefCounted
## Enum holder

enum Type {
	# Player
	CAMERA_LOCKED,   ## Camera cannot be turned.
	MOVEMENT_LOCKED, ## Player cannot move at all.
	RUN_LOCKED,      ## Player cannot run.
	LIGHT_LOCKED,    ## Flashlight cannot be toggled.
	RADAR_LOCKED,    ## Radar cannot be taken out/put away.
	INPUT_CAPTURED,  ## All input is disabled.
	
	# All
	WORLD_FROZEN,    ## Granny minigame...
}
