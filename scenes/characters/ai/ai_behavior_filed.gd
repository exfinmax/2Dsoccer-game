class_name AIBehaviorFiled
extends AIBehavior

const SHOT_DISTANCE := 150
const SHOT_POSSIBLE := 0.28
const TACKLE_DISTANCE := 15
const TACKLE_PROSSIBLE := 0.32
const PASS_POSSIBLE := 0.03

func perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	if player.has_ball():
		total_steering_force += get_carrier_steering_force()
	elif is_ball_carried_by_teammate():
			total_steering_force += get_assist_formation_steering_force()
	else:
		total_steering_force += get_onduty_steering_force()
		if total_steering_force.length() < 1:
			if is_ball_possessed_by_opponent():
				total_steering_force += get_spawn_steering_force()
			elif ball.carrier == null:
				total_steering_force += get_ball_proximity_steering_force()
				total_steering_force += get_density_around_ball_steering_force()
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed

func perform_ai_decisions() -> void:
	if is_ball_possessed_by_opponent() && player.position.distance_to(ball.position) < TACKLE_DISTANCE && randf() < TACKLE_PROSSIBLE:
			player.switch_state(Player.State.TACKLING)
	if ball.carrier == player:
		var target := player.target_goal.get_center_target_position()
		if player.position.distance_to(target) < SHOT_DISTANCE && randf() > SHOT_POSSIBLE:
			player.face_towards_target_goal()
			var shot_direction := player.position.direction_to(player.target_goal.get_random_target_position())
			var data := PlayerStateData.build().set_shot_power(player.power).set_shot_direction(shot_direction)
			player.switch_state(Player.State.SHOTING, data)
		elif randf() < PASS_POSSIBLE && has_teammate_in_view() && has_opponents_nearby():
			player.switch_state(Player.State.PASSING)

func get_onduty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)

func get_carrier_steering_force() -> Vector2:
	var target := player.target_goal.get_center_target_position()
	var direction := player.position.direction_to(target)
	var weight := get_bicircular_weight(player.position, target, 100, 0, 150, 1)
	return weight * direction

func get_assist_formation_steering_force() -> Vector2:
	var spawn_difference := ball.carrier.spawn_position - player.spawn_position
	var assist_destination := ball.carrier.position - spawn_difference * SPREAD_ASSIST_FACTOR
	var direction := player.position.direction_to(assist_destination)
	var weight := get_bicircular_weight(player.position, assist_destination, 30, 0.2, 60, 1)
	return weight * direction

func get_ball_proximity_steering_force() -> Vector2:
	var weight := get_bicircular_weight(player.position, ball.position, 50, 1, 120, 0)
	var direction := player.position.direction_to(ball.position)
	return weight * direction

func get_density_around_ball_steering_force() -> Vector2:
	var nb_teammates_near_ball = ball.get_promixty_teammate_count(player.country)
	if nb_teammates_near_ball == 0:
		return Vector2.ZERO
	var weight :float = 1.0 - 1.0 / nb_teammates_near_ball
	var direction := ball.position.direction_to(player.position)
	return weight * direction

func get_spawn_steering_force() -> Vector2:
	var weight := get_bicircular_weight(player.position, player.spawn_position, 30, 0, 100, 1)
	var direction := player.position.direction_to(player.spawn_position)
	return weight * direction

func has_teammate_in_view() -> bool:
	var players_in_view := teammate_detection_area.get_overlapping_bodies()
	return players_in_view.find_custom(func(p: Player): return p != player && p.country == player.country && p.role != Player.Role.GOALIE) > -1
