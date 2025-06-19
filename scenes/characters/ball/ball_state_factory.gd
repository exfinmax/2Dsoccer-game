class_name BallStateFactory
extends Node

var states : Dictionary

func _init() -> void:
	states = {
		Ball.State.CARRIED: BallCarried,
		Ball.State.FREEFORM: BallFreeForm,
		Ball.State.SHOT: BallShot,
	}

func get_fresh_state(state: Ball.State) -> BallState:
	assert(states.has(state), "state doesn't exist!")
	return states.get(state).new()
