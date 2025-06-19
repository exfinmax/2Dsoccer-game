class_name GameReset
extends GameState

func _enter_tree() -> void:
	GameEvents.team_reset.emit()

func _process(delta: float) -> void:
	if GameEvents.player_back_to_kickoff == 12:
		transition_state(GameManager.State.KICKOFF, game_data)
