class_name ScreenData

var tournament : Tournament = null

static  func buide() -> ScreenData:
	return ScreenData.new()

func get_tournament(current_tournament: Tournament) -> ScreenData:
	tournament = current_tournament
	return self
