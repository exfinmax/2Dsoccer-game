class_name Screen
extends Node

signal state_transition_requested(new_state: SoccerGame.ScreenType, state_data:ScreenData)

var game : SoccerGame = null
var screen_data : ScreenData = null

func set_up(context_game: SoccerGame, context_data: ScreenData) -> void:
	game = context_game
	screen_data = context_data

func transition_state(new_state :SoccerGame.ScreenType , data: ScreenData = ScreenData.new()) -> void:
	state_transition_requested.emit(new_state, data)
