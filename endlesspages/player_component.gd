@abstract
class_name PlayerComponent
extends Node
## Base class that all Player components use.

@export var _active_states: Array[Player.State]

var _player: Player

var _inactive: bool = true


func initialize(player: Player) -> void:
	_player = player


func _process(delta: float) -> void:
	if _player.get_current_state() in _active_states:
		process(delta)


func _physics_process(delta: float) -> void:
	if _player.get_current_state() in _active_states:
		physics_process(delta)


## Override in subclasses.[br]
## Called whenever the [enum Player.State] changes from one not in _active_states to one that is.
func activate() -> void:
	pass


## Override in subclasses.[br]
## Called whenever the [enum Player.State] changes from one in _active_states to one that isn't.
func deactivate() -> void:
	pass


@warning_ignore("unused_parameter")
## Override in subclasses.
func process(delta: float) -> void:
	pass


@warning_ignore("unused_parameter")
## Override in subclasses.
func physics_process(delta: float) -> void:
	pass


func _on_state_changed(new: Player.State) -> void:
	if new in _active_states:
		if _inactive:
			activate()
			_inactive = false
	else:
		if not _inactive:
			deactivate()
			_inactive = true
