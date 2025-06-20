class_name Match

var country_home : String
var country_away : String
var goal_home : int
var goal_away : int
var final_score : String
var winner : String

func _init(team_home: String, team_away:String) -> void:
	country_home = team_home
	country_away = team_away

func is_tied() -> bool:
	return goal_home == goal_away

func increase_score(country_scored_on: String) -> void:
	if country_scored_on == country_home:
		goal_away += 1
	else:
		goal_home += 1
	update_match_info()

func update_match_info() -> void:
	winner = country_home if goal_home > goal_away else country_away
	final_score = "%d - %d" % [max(goal_away,goal_home), min(goal_away, goal_home)]

func reslove() -> void:
	while is_tied():
		goal_home = randi_range(0,5)
		goal_away = randi_range(0,5)
	update_match_info()
