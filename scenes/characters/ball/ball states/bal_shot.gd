class_name BallShot
extends BallState

const  SHOT_HEIGHT := 5.0
const SHOT_SPRITE_SCALE := 0.8
const DURATION_SHOTING := 1000

var time_start_shot

func _enter_tree() -> void:
	time_start_shot = Time.get_ticks_msec()
	set_ball_animation_from_velocity()
	sprite.scale.y = SHOT_SPRITE_SCALE
	ball.height = SHOT_HEIGHT
	shot_particles.emitting = true
	GameEvents.impact_receive.emit(ball.position, true)
	
func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_start_shot > DURATION_SHOTING:
		state_transition_requested.emit(Ball.State.FREEFORM)
	else:
		move_and_bounce(delta)
		
func _exit_tree() -> void:
	sprite.scale.y = 1.0
	shot_particles.emitting = false
	
