class_name PlayerChestControl
extends PlayerState

const DURATION := 500

var time_start_control

func _enter_tree() -> void:
	animation_player.play("chest_control")
	player.velocity = Vector2.ZERO
	time_start_control = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_start_control > DURATION:
		transition_state(Player.State.MOVING)

func can_pass() -> bool:
	return true
