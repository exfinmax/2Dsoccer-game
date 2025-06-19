class_name GameState
extends Node

signal state_transition_requested(new_state: GameManager.State, data: GameData)

var manager : GameManager = null
var game_data : GameData = null

func set_up(context_manager: GameManager, context_data: GameData) -> void:
	manager = context_manager
	game_data = context_data

func transition_state(new_state: GameManager.State, new_data:GameData = GameData.new()) -> void:
	state_transition_requested.emit(new_state, new_data)
