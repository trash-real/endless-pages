class_name StateMachine
extends RefCounted
## Generic state machine.
##
## Uses int so a class can use any enum as state.[br]
## Enemy3D states, Enemy2D states, PlayerMovement states, etc.[br][br]
##
## A node can have as many StateMachines as it needs.

signal changed(from: int, to: int)

var _state: int
var _table: Dictionary
var _transitioning: bool = false


## [param table] basically gives each state a list of states it is allowed to transition to.[br]
## Typically this is just a const DEFAULT_STATE_DICT variable passed in.[br]
## Empty dict = any transition allowed.
func _init(initial: int = 0, table: Dictionary = {}) -> void:
	_state = initial
	_table = table


func get_state() -> int:
	return _state


## Check if the current state is in an array of states.[br]
## Empty array will return true.
func is_in(states: Array) -> bool:
	return states.is_empty() or _state in states


func can_enter(next: int) -> bool:
	if _table.is_empty():
		return true
	return next in _table.get(_state, [])


## Attempts to transition state.
## Returns false if rejected so callers that care can deal with it and the rest can fire and forget.
func request(next: int) -> bool:
	if _transitioning or next == _state or not can_enter(next):
		return false
	
	_transitioning = true
	var prev := _state
	_state = next
	changed.emit(prev, next)
	_transitioning = false
	return true
