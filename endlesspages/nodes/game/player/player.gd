class_name Player
extends CharacterBody3D
## The player. All behavior comes from [PlayerComponent]s.
##
## This node handles:[br]
## - State machine management.[br]
## - Forwarding ticks to the [ComponentHost].[br]
## - Applying movement.

@export var stats: PlayerStats

var movement_state: StateMachine = StateMachine.new(PlayerMovement.MovementState.STILL)
var light_state: StateMachine = StateMachine.new(PlayerFlashlightController.LightState.ON)

@onready var components: ComponentHost = ComponentHost.new(self)


func _ready() -> void:
	components.setup()
	
	Constraints.changed.connect(components.refresh_all)
	movement_state.changed.connect(func(_a, _b): components.refresh_all())
	light_state.changed.connect(func(_a, _b): components.refresh_all())
	
	enable()


func _process(delta: float) -> void:
	components.tick(delta)


func _physics_process(delta: float) -> void:
	components.physics_tick(delta)
	
	if components.running:
		move_and_slide()


func enable() -> void:
	components.start()


func disable() -> void:
	components.stop()
