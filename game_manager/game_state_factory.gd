class_name GameFactory
extends Node

var states : Dictionary

func _init() -> void:
	states = {
		GameManager.State.IN_PLAY : GameInPlay,
		GameManager.State.SCORED : GameScored,
		GameManager.State.RESET : GameReset,
		GameManager.State.KICKOFF : GameKickoff,
		GameManager.State.OVERTIME : GameOverTime,
		GameManager.State.GAMEOVER : GameOver,
	}
func get_fresh_state(state: GameManager.State) -> GameState:
	assert(states.has(state), "state doesn't exist!")
	return states.get(state).new()
