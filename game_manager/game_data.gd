class_name GameData

var country_scored_on : String

static func bulid() -> GameData:
	return GameData.new()

func set_country_scored_on(country: String) -> GameData:
	country_scored_on = country
	return self
