class_name  PlayerState
extends Node

signal state_transition_requested(new_state: Player.State, state_data:PlayerStateData)

var ai_behavior : AIBehavior = null
var animation_player : AnimationPlayer = null
var ball : Ball
var ball_dection_area : Area2D = null
var player : Player = null
var state_data : PlayerStateData = PlayerStateData.new()
var teammate_dection: Area2D
var own_goal : Goal = null
var target_goal : Goal = null
var tackle_damage_emitter_area : Area2D = null

func set_up(context_player: Player,context_data: PlayerStateData, context_animation_player: AnimationPlayer,context_ball: Ball, context_teammate_dection: Area2D, context_ball_detection: Area2D, context_own_goal: Goal, context_target_goal: Goal, context_ai_behavior: AIBehavior, context_tackle_damage_emitter_area: Area2D) -> void:
	player = context_player
	animation_player = context_animation_player
	state_data = context_data
	ball = context_ball
	teammate_dection = context_teammate_dection
	ball_dection_area = context_ball_detection
	own_goal = context_own_goal
	target_goal = context_target_goal
	ai_behavior = context_ai_behavior
	tackle_damage_emitter_area = context_tackle_damage_emitter_area
	
func transition_state(new_state : Player.State, data: PlayerStateData = PlayerStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)

func on_animation_complete() -> void:
	pass

func can_carry_ball() -> bool:
	return false

func can_pass() -> bool:
	return false
