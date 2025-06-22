class_name WorldScreen
extends Screen

const DURATION := 3000

var time_start_game_over
var is_over :bool = false


	
func _ready() -> void:
	GameEvents.game_over.connect(on_game_over.bind())
	GameManager.start_game()
	GameEvents.control_change.emit(false)

func _process(delta: float) -> void:
	if is_over:
		if Time.get_ticks_msec() - time_start_game_over > DURATION:
			GameEvents.control_change.emit(true)
			if screen_data.tournament != null && GameManager.current_match.winner == GameManager.player_setup[0]:
				screen_data.tournament.advance()
				transition_state(SoccerGame.ScreenType.TOURNAMENT, screen_data)
			else:
				transition_state(SoccerGame.ScreenType.MAIN_MENU)

func on_game_over(_country_winner: String) -> void:
	time_start_game_over = Time.get_ticks_msec()
	is_over = true
