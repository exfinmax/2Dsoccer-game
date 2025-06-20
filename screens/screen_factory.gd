class_name Screenfactory

var type : Dictionary

func _init() -> void:
	type = {
		SoccerGame.ScreenType.MAIN_MENU: preload("res://screens/mainmenu/main_menu.tscn"),
		SoccerGame.ScreenType.TEAM_SELECTION: preload("res://screens/teamselection/team_selection_screen.tscn"),
		SoccerGame.ScreenType.TOURNAMENT: preload("res://screens/tournamentscreen/tournament_screen.tscn"),
		SoccerGame.ScreenType.IN_GAME: preload("res://screens/world/worldscreen.tscn"),
	}

func get_fresh_state(state: SoccerGame.ScreenType) -> Screen:
	assert(type.has(state), "state doesn't exist!")
	return type.get(state).instantiate()
