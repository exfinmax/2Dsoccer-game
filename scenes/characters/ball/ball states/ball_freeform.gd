class_name BallFreeForm
extends BallState


const MAX_CAPTURE_HEIGHT := 25

var time_start_freefrom

func _enter_tree() -> void:
	player_dection_area.monitoring = false
	player_dection_area.body_entered.connect(on_player_enter.bind())
	time_start_freefrom = Time.get_ticks_msec()
	
func on_player_enter(body: Player) -> void:
	if body.can_carry_ball() && ball.height < MAX_CAPTURE_HEIGHT:
		ball.carrier = body
		body.control_ball()
		state_transition_requested.emit(Ball.State.CARRIED)

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_start_freefrom > ball_data.lock_duration:
		player_dection_area.monitoring = true
	set_ball_animation_from_velocity()
	var friction := ball.friction_air if ball.height > 0 else ball.friction_ground
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, ball.BOUNCINESS)
	move_and_bounce(delta)

func _exit_tree() -> void:
	player_dection_area.monitoring = true

func can_air_interact() -> bool:
	return true
