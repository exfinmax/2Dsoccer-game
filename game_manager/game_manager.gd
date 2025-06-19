extends Node

const DURATION_GAME_SEC := 120
const DURATION_IMPACT_PAUSE := 100

enum State {IN_PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAMEOVER}

var current_match : Match = null
var time_left : float 
var current_state : GameState = null
var state_factory := GameFactory.new()
var player_setup : Array[String] = ["FRANCE", ""]
var time_since_impact := Time.get_ticks_msec()

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	time_left = DURATION_GAME_SEC
	GameEvents.impact_receive.connect(on_spark_spawn.bind())

func _physics_process(delta: float) -> void:
	if get_tree().paused && Time.get_ticks_msec() - time_since_impact > DURATION_IMPACT_PAUSE:
		get_tree().paused = false

func switch_state(state: State, data : GameData = GameData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.set_up(self, data)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "GameStateMachine: " + str(state)
	call_deferred("add_child", current_state)

func is_coop() -> bool:
	return player_setup[0] == player_setup[1]
	
func is_singal_player() -> bool:
	return player_setup[1].is_empty() 



func get_winner_country() -> String:
	assert(not current_match.is_tied())
	return current_match.winner

func increase_score(country_scored_on: String) -> void:
	current_match.increase_score(country_scored_on)
	GameEvents.score_changed.emit()

func on_spark_spawn(_position: Vector2, flag: bool) -> void:
	if flag:
		time_since_impact = Time.get_ticks_msec()
		get_tree().paused = true

func start_game() -> void:
	switch_state(State.RESET)
