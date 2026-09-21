@abstract
class_name Component
extends Node
## Base class for every component managed by a [ComponentHost].
##
## The host enables/disables components automatically.

## Lower value = tick sooner.
@export var tick_priority: int = 0

var enabled: bool = false

var _host: ComponentHost
var _binds: Array[Binding] = []


## [color=red][b]DO NOT OVERRIDE![/b][/color][br][br]
## Handles caching [ComponentHost] and setting process mode to false (handled by host).
func setup(c_host: ComponentHost) -> void:
	_host = c_host
	
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
			_connect_signals()
			activate()
		else:
			deactivate()
			_disconnect_signals()
	 
	state_changed()


## Component signal handler.
## 
## Auto connects/disconnects signal to specified callable on activate/deactivate.
class Binding:
	var sig: Signal
	var handler: Callable
	func _init(s: Signal, h: Callable) -> void:
		sig = s
		handler = h


## Automatic signal connection/disconnection on activate/deactivate.
func create_bind(sig: Signal, handler: Callable) -> void:
	_binds.push_back(Binding.new(sig, handler))


func _connect_signals() -> void:
	for bind in _binds:
		if not bind.sig.is_connected(bind.handler):
			bind.sig.connect(bind.handler)


func _disconnect_signals() -> void:
	for bind in _binds:
		if bind.sig.is_connected(bind.handler):
			bind.sig.disconnect(bind.handler)


## Override in subclasses that have their own state machine logic to decide this.[br][br]
## Call super() and then check the state machine.
## [codeblock]
## return super() and state_machine.is_active()
func _is_active() -> bool:
	return _host.running


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
