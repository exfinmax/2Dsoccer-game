class_name PlayerCelebrate
extends PlayerState

const CELEBRATING_HEIGHT := 2.0
const AIR_FRICTION := 35.0

var initial_delay := randi_range(200, 500)
var time_start_clelbrate

func _enter_tree() -> void:
	GameEvents.team_reset.connect(on_team_reset.bind())
	time_start_clelbrate = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if player.height == 0 && Time.get_ticks_msec() - time_start_clelbrate > initial_delay:
		celebrate()
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)

func celebrate() -> void:
	animation_player.play("celebrate")
	player.height = 0.1
	player.height_velocity = CELEBRATING_HEIGHT

func on_team_reset() -> void:
	transition_state(Player.State.RESET, PlayerStateData.build().set_reset_position(player.spawn_position))
