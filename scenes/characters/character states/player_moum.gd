class_name PlayerMoum
extends PlayerState

func _enter_tree() -> void:
	animation_player.play("moum")
	player.velocity = Vector2.ZERO
	GameEvents.team_reset.connect(on_team_reset.bind())

func on_team_reset() -> void:
	transition_state(Player.State.RESET, PlayerStateData.build().set_reset_position(player.kick_position))
