class_name UI
extends CanvasLayer

@onready var goal_scorer_label: Label = %GoalScorerLabel
@onready var score_info_label: Label = %ScoreInfoLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var flag_textures :Array[TextureRect] = [%HomeflagTexture, %AwayflagTexture]
@onready var player_lable: Label = %PlayerLable
@onready var score_label: Label = %ScoreLabel
@onready var time_lable: Label = %TimeLable

var last_ball_carrier: String
var is_first_reset := false

func _ready() -> void:
	update_score()
	update_flags()
	update_clock()
	GameEvents.ball_possessed.connect(on_ball_possessed.bind())
	GameEvents.ball_released.connect(on_ball_released.bind())
	GameEvents.score_changed.connect(on_score_changed.bind())
	GameEvents.team_reset.connect(on_team_reset.bind())
	GameEvents.game_over.connect(on_game_over.bind())
	
func update_score() -> void:
	score_label.text = ScoreHelper.get_score_text(GameManager.current_match)

func update_flags() -> void:
	for i in flag_textures.size():
		var countries := [GameManager.current_match.country_home, GameManager.current_match.country_away]
		flag_textures[i].texture = TextureHelper.get_texture(countries[i])

func update_clock() -> void:
	if GameManager.time_left < 0:
		time_lable.modulate = Color.YELLOW
	time_lable.text = TimeHelper.get_time_text(GameManager.time_left)

func _process(_delta: float) -> void:
	update_clock()
	
func on_ball_possessed(player_name: String) -> void:
	player_lable.text = player_name
	last_ball_carrier = player_name
	
func on_ball_released() -> void:
	player_lable.text = ""

func on_score_changed() -> void:
	if GameManager.time_left > 0:
		goal_scorer_label.text = "%s SCORED!" % [last_ball_carrier]
		score_info_label.text = ScoreHelper.get_current_score_info(GameManager.current_match)
		animation_player.play("goal_appear")
	update_score()

func on_team_reset() -> void:
	if !is_first_reset:
		is_first_reset = true
		return
	animation_player.play("goal_hide")

func on_game_over(_country_winner: String) -> void:
	score_info_label.text = ScoreHelper.get_final_score_info(GameManager.current_match)
	animation_player.play("game_over")
