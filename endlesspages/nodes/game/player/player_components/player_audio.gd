class_name PlayerAudio
extends PlayerComponent
## Handles all player-related audio.

@export var _step_event: AudioEvent
@export var _step_player: AudioStreamPlayer3D

var _bob: PlayerCameraBob


func init() -> void:
	super()
	
	_bob = _host.get_component(PlayerCameraBob)
	
	create_bind(_bob.stepped, _on_stepped)


func _on_stepped() -> void:
	_step_player.stream = _step_event.stream
	_step_player.bus = _step_event.bus
	_step_player.volume_db = _step_event.volume_db
	_step_player.play()
