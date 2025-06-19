class_name AIBehavior
extends Node

const AI_TICK_FREQUENCY := 200
const SPREAD_ASSIST_FACTOR := 0.8


var ball : Ball = null
var opponent_detection_area :Area2D = null
var player : Player = null
var teammate_detection_area : Area2D = null
var time_since_last_ai_tick 

func _ready() -> void:
	time_since_last_ai_tick = Time.get_ticks_msec() + randi_range(0, AI_TICK_FREQUENCY)


func set_up(context_player: Player, context_ball: Ball, context_opponent_detection_area : Area2D, context_teammate_detection_area: Area2D) -> void:
	player = context_player
	ball = context_ball
	opponent_detection_area = context_opponent_detection_area
	teammate_detection_area = context_teammate_detection_area

func process_ai() -> void:
	if Time.get_ticks_msec() - time_since_last_ai_tick > AI_TICK_FREQUENCY:
		time_since_last_ai_tick = Time.get_ticks_msec()
		perform_ai_movement()
		perform_ai_decisions()

func perform_ai_movement() -> void:
	pass

func perform_ai_decisions() -> void:
	pass


	
func get_bicircular_weight(position: Vector2, center_target: Vector2, inner_r: float,inner_weight: float, outer_r: float, outer_weight:float ) -> float:
	var distance_to_center := position.distance_to(center_target)
	if distance_to_center > outer_r:
		return outer_weight
	elif distance_to_center < inner_r:
		return inner_weight
	else:
		var distance_to_inner_r := distance_to_center - inner_r
		var close_range_distance := outer_r - inner_r
		return lerpf(inner_weight, outer_weight, distance_to_inner_r / close_range_distance)



func is_ball_possessed_by_opponent() -> bool:
	return ball.carrier != null && ball.carrier.country != player.country

func is_ball_carried_by_teammate() -> bool:
	return ball.carrier != null && ball.carrier != player && ball.carrier.country == player.country

func has_opponents_nearby() -> bool:
	var players := opponent_detection_area.get_overlapping_bodies()
	return players.find_custom(func(p: Player): return p.country != player.country) > -1
