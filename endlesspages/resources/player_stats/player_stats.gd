class_name PlayerStats
extends Resource
## Holds all stats that affect the player.
##
## For endless mode, a new one should be made using the selected character's default PlayerStats resource as a template.[br]
## All mid-run stat changes should be applied to the duplicate.

@export_group("Movement")
## Player speed while moving.
@export var walk_speed: float = 3.5
## Player speed while moving and holding shift.
@export var run_speed: float = 5.0
## How quickly the player gets to their desired speed. Higher = faster.
@export var acceleration: float = 10.0

@export_group("Flashlight", "light_")
## Determines SpotLight3D's range value.[br]
## Should also increase range at which monsters are repelled by the light.
@export var light_range: float = 50.0
## Determines SpotLight3D's energy value.[br]
## Could affect light sensitive characters, repelling them faster.
@export var light_power: float = 10.0
## Determines SpotLight3D's angle value.[br]
## Degree angle of spotlight.
@export var light_angle: float = 45.0

@export_group("Radar", "radar_")
## 1.0 battery = 1 second.
@export var radar_start_battery: float = 40.0
## Maximum amount of battery.
@export var radar_max_battery: float = 60.0
## Amount per second the radar battery drains.
@export var radar_drain_per_sec: float = 1.0

@export_group("Movement")


@export_group("Movement")
