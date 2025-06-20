class_name TournamentScreen
extends Node

const STAGE_TEXTURE := {
	Tournament.Stage.QUARTED_FINAL: preload("res://assets/art/ui/teamselection/quarters-label.png"),
	Tournament.Stage.SEMI_FINAL: preload("res://assets/art/ui/teamselection/semis-label.png"),
	Tournament.Stage.FINAL: preload("res://assets/art/ui/teamselection/finals-label.png"),
	Tournament.Stage.COMPLETE: preload("res://assets/art/ui/teamselection/winner-label.png"),
	
}

@onready var flag_container : Dictionary = {
	Tournament.Stage.QUARTED_FINAL: [%QFleftContainer, %QFrightContainer],
	Tournament.Stage.SEMI_FINAL: [%SEleftContainer, %SErightContainer],
	Tournament.Stage.FINAL: [%FIleftContainer, %FIrightContainer],
	Tournament.Stage.COMPLETE: [%WinnerContainer],
}
@onready var stage_texture: TextureRect = %StageTexture


var player_country : String = GameManager.player_setup[0]
var tournamenet : Tournament = null

func _ready() -> void:
	tournamenet = Tournament.new()
	refresh_ui()

func _process(delta: float) -> void:
	if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.SHOOT):
		tournamenet.advance()
		refresh_ui()

func refresh_ui() -> void:
	for stage in range(tournamenet.current_stage + 1):
		refresh_bracket_stage(stage)

func refresh_bracket_stage(stage: Tournament.Stage) -> void:
	var flag_nodes := get_flag_nodes_for_stage(stage)
	stage_texture.texture = STAGE_TEXTURE[stage]
	if stage < Tournament.Stage.COMPLETE:
		var matchs : Array = tournamenet.matchs[stage]
		assert(flag_nodes.size() == 2 * matchs.size())
		for i in range(matchs.size()):
			var current_match : Match = matchs[i]
			var flag_home : BracketFlag = flag_nodes[i*2]
			var flag_away : BracketFlag = flag_nodes[i*2+1]
			flag_home.texture = TextureHelper.get_texture(current_match.country_home)
			flag_away.texture = TextureHelper.get_texture(current_match.country_away)
			if not current_match.winner.is_empty():
				var flag_winner := flag_home if current_match.winner == current_match.country_home else flag_away
				var flag_loser := flag_home if current_match.winner == current_match.country_away else flag_away
				flag_winner.set_as_winner(current_match.final_score)
				flag_loser.set_as_loser()
			elif [current_match.country_home, current_match.country_away].has(player_country) && stage == tournamenet.current_stage:
				var flag_player := flag_home if current_match.country_home == player_country else flag_away
				flag_player.set_as_current_team()

	else:
		
		flag_nodes[0].texture = TextureHelper.get_texture(tournamenet.winner)
		
func get_flag_nodes_for_stage(stage: Tournament.Stage) -> Array[BracketFlag]:
	var flag_nodes : Array[BracketFlag] = []
	for container in flag_container.get(stage):
		for node in container.get_children():
			if node is BracketFlag:
					flag_nodes.append(node)
	return flag_nodes
