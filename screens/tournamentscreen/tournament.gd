class_name Tournament

enum Stage {
	QUARTED_FINAL,
	SEMI_FINAL,
	FINAL,
	COMPLETE,
}

var current_stage : Stage = Stage.QUARTED_FINAL
var matchs := {
	Stage.QUARTED_FINAL: [],
	Stage.SEMI_FINAL: [],
	Stage.FINAL: [],
}
var winner := ""

func _init() -> void:
	var countries :Array[String]= DataLoader.get_countries().slice(1, 9)
	countries.shuffle()
	create_bracket(current_stage, countries)

func create_bracket(stage: Stage, current_countries:Array[String]) -> void:
	for i in range(int(current_countries.size() / 2)):
		matchs[stage].append(Match.new(current_countries[i*2], current_countries[i*2+1]))

func advance() -> void:
	if current_stage < Stage.COMPLETE:
		var stage_matchs : Array = matchs[current_stage]
		var stage_winners : Array[String] = []
		for current_match : Match in stage_matchs:
			current_match.reslove()
			stage_winners.append(current_match.winner)
		current_stage += 1 as Stage
		if current_stage == Stage.COMPLETE:
			winner = stage_winners[0]
		else:
			create_bracket(current_stage, stage_winners)
