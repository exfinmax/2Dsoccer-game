class_name Camera
extends Camera2D

const DISTANCE_TARGET := 75.0
const DURATION_SHAKE := 120
const SHAKE_INSTANCE := 5
const SMOOTHING_BALL_CARRIED := 2
const SMOOTHING_BALL_DEFAULT := 8

var is_shaking := false
var time_start_shake

@export var ball : Ball

func _init() -> void:
	GameEvents.impact_receive.connect(on_spark_spawn.bind())

func _process(delta: float) -> void:
	var tween = create_tween()
	if ball.carrier != null:
		tween.tween_property(self, "position", ball.carrier.position + ball.carrier.heading * DISTANCE_TARGET,delta)
		position_smoothing_speed = SMOOTHING_BALL_CARRIED
	else:
		tween.tween_property(self, "position", ball.position, delta)
		position_smoothing_speed = SMOOTHING_BALL_DEFAULT
	if is_shaking:
		offset = Vector2(randf_range(-SHAKE_INSTANCE,SHAKE_INSTANCE), randf_range(-SHAKE_INSTANCE,SHAKE_INSTANCE))
		if Time.get_ticks_msec() - time_start_shake > DURATION_SHAKE:
			is_shaking = false
			offset = Vector2.ZERO

func on_spark_spawn(_impact_position: Vector2, flag: bool) -> void:
	if flag && GameEvents.setting_varrent[2] == 1:
		is_shaking = true
		time_start_shake = Time.get_ticks_msec()
