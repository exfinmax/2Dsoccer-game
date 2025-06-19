class_name GameScored
extends GameState

const DURATION_CELEBRATION := 3000

var time_since_celebration

func _enter_tree() -> void:
	manager.increase_score(game_data.country_scored_on)
	time_since_celebration = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_since_celebration > DURATION_CELEBRATION:
		transition_state(GameManager.State.RESET, game_data)
