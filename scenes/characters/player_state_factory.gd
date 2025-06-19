class_name PlayerStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		Player.State.MOVING: PlayerMove,
		Player.State.RECOVERING: PlayerRecover,
		Player.State.TACKLING: PlayerTackle,
		Player.State.PREPPING_SHOT : PlayerPrepShot,
		Player.State.SHOTING : PlayerShot,
		Player.State.PASSING : PlayerPass,
		Player.State.HEADER : PlayerHeader,
		Player.State.VOLLEY_KICK : PlayerVolleyKick,
		Player.State.BICYCLE_KICK : PlayerBicycleKick,
		Player.State.CHEST_CONTROL : PlayerChestControl,
		Player.State.HURT : PlayerHurt,
		Player.State.DIVING : PlayerDiving,
		Player.State.MOUMING : PlayerMoum,
		Player.State.CELEBRATING: PlayerCelebrate,
		Player.State.RESET: PlayerReset,
	}

func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "state doesn't exist!")
	return states.get(state).new()
