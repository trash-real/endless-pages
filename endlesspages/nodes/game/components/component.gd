@abstract
class_name Component
extends Node
## Base class for every component managed by a [ComponentHost].
##
## The host enables/disables components automatically.

## Lower value = tick sooner.
@export var tick_priority: int = 0

var host: ComponentHost
var enabled: bool = false


## [color=red][b]DO NOT OVERRIDE![/b][/color][br][br]
## Handles caching [ComponentHost] and setting process mode to false (handled by host).
func setup(c_host: ComponentHost) -> void:
	host = c_host
	
	# Host decides tick order instead
	set_process(false)
	set_physics_process(false)
	
	init()


## Decides whether this component should run.
func refresh() -> void:
	var should_be: bool = _is_active()
	if should_be != enabled:
		enabled = should_be
		if enabled:
			activate()
		else:
			deactivate()
	 
	state_changed()


## Override in subclasses that have their own state machine logic to decide this.[br][br]
## Call super() and then check the state machine.
## [codeblock]
## return super() and state_machine.is_active()
func _is_active() -> bool:
	return host.running


## Override in subclasses.[br]
## Deal with sibling components, references, etc. here.
func init() -> void:
	pass


## Override in subclasses.[br]
## Runs only while enabled.
@warning_ignore("unused_parameter")
func tick(delta: float) -> void:
	pass


## Override in subclasses.[br]
## Runs only while enabled.
@warning_ignore("unused_parameter")
func physics_tick(delta: float) -> void:
	pass


## Override in subclasses.[br]
## Called when the component transitions from not running to running.
func activate() -> void:
	pass


## Override in subclasses.[br]
## Called when the component transitions from running to not running.[br]
## Release any constraints applied to the player here, etc.
func deactivate() -> void:
	pass


## Override in subclasses.[br]
## Called on every refresh, whether or not enabled changed.
func state_changed() -> void:
	pass
