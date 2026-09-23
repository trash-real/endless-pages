class_name PlayerFlashlightAttract
extends PlayerComponent
## Handles rotating the flashlight toward objects it is currently attracted to.

signal interact_attractor_updated(target: Node3D)

var _interaction: PlayerInteraction

var _interact_attractor: Node3D


func init() -> void:
	super()
	
	_interaction = _host.get_component(PlayerInteraction)
	
	create_bind(_interaction.target_changed, _on_interaction_target_changed)


func get_attraction_position() -> Variant:
	if _interact_attractor == null:
		return null
	return _interact_attractor.global_position


func _on_interaction_target_changed(new: InteractibleComponent) -> void:
	if new == null:
		_interact_attractor = null
		interact_attractor_updated.emit(_interact_attractor)
		return
	
	for child in new.get_parent().get_children():
		if child is FlashlightAttractorComponent:
			_interact_attractor = child.target
	
	interact_attractor_updated.emit(_interact_attractor)
