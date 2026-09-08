class_name Player
extends CharacterBody3D
## Player base script.
##
## Handles Player state machine.

signal state_changed(new: State)

enum State {
	INIT,   # Game starting, init components
	ACTIVE, # Normal active state
	PAUSED, # Not active, but needs to be reactivated
	DEAD,   # Not going to be reactivated
}

var _current_state: State = State.INIT:
	set(value):
		_current_state = value
		state_changed.emit(value)


# TEMP
func _ready() -> void:
	request_state_change(State.ACTIVE)


func request_state_change(new: State):
	# if allowed logic
	
	# Change State
	_current_state = new


func get_current_state() -> State:
	return _current_state
