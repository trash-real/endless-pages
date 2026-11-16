extends Node
## Manages (pretty much) everything related to audio.
##
## Enemies that emit looping sounds own those sound effects so they are automatically deleted on death.

var _audio_players: Array[AudioStreamPlayer]
var _audio_players_3d: Array[AudioStreamPlayer3D]

const AUDIO_PLAYERS: int = 8
const AUDIO_PLAYERS_3D: int = 8


func _ready() -> void:
	_create_audio_players()


## Plays a sound from an audio player in the pool.
func play_one_shot_nondirectional(event: AudioEvent, overwrite: bool = true) -> void:
	var player := _find_audio_player(overwrite)
	if not is_instance_valid(player):
		return
	player.stream = event.stream
	player.bus = event.bus
	player.volume_db = event.volume_db
	player.play()


func play_one_shot_at_position(event: AudioEvent, pos: Vector3, overwrite: bool = true) -> void:
	var player := _find_audio_player_3d(overwrite)
	if not is_instance_valid(player):
		return
	player.stream = event.stream
	player.bus = event.bus
	player.volume_db = event.volume_db
	player.global_position = pos
	player.play()


## Creates audio players and adds them to the pool.
func _create_audio_players() -> void:
	for i in range(AUDIO_PLAYERS):
		var a := AudioStreamPlayer.new()
		a.autoplay = false
		_audio_players.push_back(a)
		add_child(a)
		print("Created AudioStreamPlayer")
	
	for i in range(AUDIO_PLAYERS_3D):
		var a := AudioStreamPlayer3D.new()
		a.autoplay = false
		_audio_players_3d.push_back(a)
		add_child(a)
		print("Created AudioStreamPlayer3D")


## Finds a free AudioStreamPlayer in the pool to use.
## If all audio players being used, return the audio player that's been playing for the longest.
func _find_audio_player(overwrite: bool = true) -> AudioStreamPlayer:
	var longest: AudioStreamPlayer = null
	for player in _audio_players:
		if not player.playing:
			return player
		
		if not is_instance_valid(longest):
			longest = player
			continue
		
		if player.get_playback_position() > longest.get_playback_position():
			longest = player
	
	if not overwrite:
		return null
	
	return longest


## Finds a free AudioStreamPlayer3D in the pool to use.
## If all audio players being used, return the audio player that's been playing for the longest.
func _find_audio_player_3d(overwrite: bool = true) -> AudioStreamPlayer3D:
	var longest: AudioStreamPlayer3D = null
	for player in _audio_players_3d:
		if not player.playing:
			return player
		
		if not is_instance_valid(longest):
			longest = player
			continue
		
		if player.get_playback_position() > longest.get_playback_position():
			longest = player
	
	if not overwrite:
		return null
	
	return longest
