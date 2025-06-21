extends Node

enum Sound{
	BOUNCE,
	HURT,
	PASS,
	POWERSHOT,
	SHOT,
	TACKLING,
	UI_NAV,
	UI_SELECT,
	WHISTLE,
}

const NB_CHANNELS := 4
const SFX_MAP : Dictionary[Sound, AudioStream] = {
	Sound.BOUNCE: preload("res://assets/sfx/bounce.wav"),
	Sound.HURT: preload("res://assets/sfx/hurt.wav"),
	Sound.PASS: preload("res://assets/sfx/pass.wav"),
	Sound.POWERSHOT: preload("res://assets/sfx/power-shot.wav"),
	Sound.SHOT: preload("res://assets/sfx/shoot.wav"),
	Sound.TACKLING: preload("res://assets/sfx/tackle.wav"),
	Sound.UI_NAV: preload("res://assets/sfx/ui-navigate.wav"),
	Sound.UI_SELECT: preload("res://assets/sfx/ui-select.wav"),
	Sound.WHISTLE: preload("res://assets/sfx/whistle.wav"),
}

var stream_players :Array[AudioStreamPlayer] = []

func _ready() -> void:
	GameEvents.set_change.connect(on_set_change.bind())
	for i in range(NB_CHANNELS):
		var stream_player := AudioStreamPlayer.new()
		stream_player.bus = "SFX"
		stream_players.append(stream_player)
		call_deferred("add_child", stream_player)

func play(sound: Sound) -> void:
	var stream_player := find_available_player()
	if stream_player != null:
		stream_player.stream = SFX_MAP[sound]
		stream_player.play()

func find_available_player() -> AudioStreamPlayer:
	for stream_player in stream_players:
		if not stream_player.playing:
			return stream_player
	return null

func on_set_change() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(GameEvents.setting_varrent[1] / 10.0)) 
