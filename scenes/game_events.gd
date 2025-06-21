extends Node

signal ball_possessed(carrier: String)
signal ball_released
signal game_over(country_winner: String)
signal kickoff_started
signal score_changed
signal impact_receive(impact_position: Vector2, is_high_impact: bool)
signal team_scored(country_scored_on: String)
signal team_reset
signal set_change

var player_back_to_kickoff :int = 0 
var setting_varrent : Array[int] = [5,5,1,0]
