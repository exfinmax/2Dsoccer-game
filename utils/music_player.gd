extends AudioStreamPlayer

enum Music {NONE, GAMEPLAY, MENU, TOURNAMENT, WIN}

const MUSIC_MAP :Dictionary[Music, AudioStream] = {
	Music.GAMEPLAY: preload("res://assets/music/gameplay.mp3"),
	Music.MENU: preload("res://assets/music/menu.mp3"),
	Music.TOURNAMENT: preload("res://assets/music/tournament.mp3"),
	Music.WIN: preload("res://assets/music/win.mp3")
}

var current_music := Music.NONE


func _ready() -> void:
	GameEvents.set_change.connect(on_set_change.bind())
	process_mode = Node.PROCESS_MODE_ALWAYS
	bus = "Music"
	
func play_music(music: Music) -> void:
	if music != current_music && MUSIC_MAP.has(music):
		stream = MUSIC_MAP.get(music)
		current_music = music
		play()
		
func on_set_change() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(GameEvents.setting_varrent[0] / 10.0)) 
