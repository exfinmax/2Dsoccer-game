class_name  PlayerHurt
extends PlayerState

const AIR_FRICTION := 35.0
const DURATION_HURT := 1000
const BALL_TUMBLE_SPEED := 100.0
const HURT_START_VELOCITY := 3.0

var time_srart_hurt 

func _enter_tree() -> void:
	animation_player.play("hurt")
	time_srart_hurt = Time.get_ticks_msec()
	player.height_velocity = HURT_START_VELOCITY
	if ball.carrier == player:
		ball.tumble(state_data.shot_direction * BALL_TUMBLE_SPEED)
		SoundPlayer.play(SoundPlayer.Sound.HURT)
		GameEvents.impact_receive.emit(player.position, false)
		
func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_srart_hurt > DURATION_HURT:
		transition_state(Player.State.RECOVERING)
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)
