class_name PlayerPrepShot
extends PlayerState

const DURATION_MAX_BONUS := 1000.0
const EASE_REWARD_FACTOR := 2.0

var time_since_prep
var shot_direction := Vector2.ZERO

func _enter_tree() -> void:
	animation_player.play("prep_kick")
	player.velocity = Vector2.ZERO
	time_since_prep = Time.get_ticks_msec()
	shot_direction = player.heading

func _process(delta: float) -> void:
	shot_direction += KeyUtils.get_input_vector(player.control_scheme) * delta
	if KeyUtils.is_action_just_released(player.control_scheme, KeyUtils.Action.SHOOT):
		var duration_press := clampf(Time.get_ticks_msec() - time_since_prep, 0.0, DURATION_MAX_BONUS)
		var ease_time := duration_press / DURATION_MAX_BONUS
		var bonus := ease(ease_time,EASE_REWARD_FACTOR)
		var shot_power := player.power * (1 + bonus)
		shot_direction = shot_direction.normalized()
		var data = PlayerStateData.build().set_shot_power(shot_power).set_shot_direction(shot_direction)
		state_transition_requested.emit(Player.State.SHOTING, data)

func can_pass() -> bool:
	return true
