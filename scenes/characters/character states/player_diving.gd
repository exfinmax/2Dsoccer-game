class_name PlayerDiving
extends PlayerState

const DURATION_DIVE := 500

var time_start_dive

func _enter_tree() -> void:
	var target_dive := Vector2(player.spawn_position.x, ball.position.y)
	var direction := player.position.direction_to(target_dive)
	if direction.y > 0:
		animation_player.play("dive_down")
		player.velocity = direction * player.speed
	elif direction.y < 0:
		animation_player.play("dive_up")
		player.velocity = direction * player.speed
	time_start_dive = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_start_dive > DURATION_DIVE:
		transition_state(Player.State.RECOVERING)

func can_pass() -> bool:
	return true
