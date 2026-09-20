class_name ComponentHost
extends RefCounted
## Manages a node's [Component]s.
##
## It finds, initializes, ticks, and keeps tracks of which components should be running.[br]
## Reusable across any nodes that use components.[br][br]
## [b]Host nodes should follow this pattern:
## [codeblock]
## @onready var components := ComponentHost.new(self)
##
## func _ready() -> void:
##     components.setup()
##     state_machine.changed.connect(components.refresh_all)
##     components.start()
## [/codeblock]

## Node that these components belong to. Components reach this using host.node.
var node: Node

## False until start(). Components are disabled until true.
var running: bool = false

var _components: Array[Component] = []
var _by_script: Dictionary = {}


func _init(parent: Node) -> void:
	node = parent


## [b]Finds child components and initializes them.[/b][br][br]
## Call before connecting any state machines or behavior will likely not be correct.
func setup() -> void:
	for child in node.find_children("*", "Component", true, false):
		var c := child as Component
		if c == null:
			continue
		_components.append(c)
		_by_script[c.get_script()] = c
	
	# Order by tick priority
	_components.sort_custom(
		func(a: Component, b: Component) -> bool:
			return a.tick_priority < b.tick_priority
	)
	
	for c in _components:
		c.setup(self)


## Brings components online. Call after every state machine is connected.
func start() -> void:
	running = true
	refresh_all()


## Brings components offline. Always call before freeing.
func stop() -> void:
	running = false
	refresh_all()


## Called by parent.
func tick(delta: float) -> void:
	for c in _components:
		if c.enabled:
			c.tick(delta)
 
 
## Called by parent.
func physics_tick(delta: float) -> void:
	for c in _components:
		if c.enabled:
			c.physics_tick(delta)


## [b]Refreshes all components.[/b][br][br]
## If calling from a signal that has arguments, do this instead:
## [codeblock]
## _signal.connect(func(_a, _b, ...): components.refresh_all())
## [/codeblock]
func refresh_all() -> void:
	for c in _components:
		c.refresh()


## [b]Easy lookup for sibling components.[/b][br][br]
## Do not use per frame. Use to cache references in [method Component.init].
## [codeblock]
## get_component(PlayerMovementComponent)
## [/codeblock]
func get_component(script: Script) -> Component:
	return _by_script.get(script)
