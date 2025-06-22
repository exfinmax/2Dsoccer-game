class_name Player
extends CharacterBody2D

signal swap_requested(player: Player)

const BALL_CONTROL_HEIGHT_MAX := 10.0
const CONTROL_SCHEME_MAP : Dictionary = {
	ControlScheme.CPU : preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1 : preload("res://assets/art/props/1p.png"),
	ControlScheme.P2 : preload("res://assets/art/props/2p.png")
}
const GRAVITY := 8.0
const WALK_ANIM_THRESHOLD := 0.6

enum ControlScheme {CPU, P1, P2}
enum Role {GOALIE, DEFFNSE, MIDFIELD, OFFENSE}
enum SkinColor {LIGHT, MEDIUM, DARK}
enum State{
	MOVING,
	TACKLING,
	RECOVERING,
	PREPPING_SHOT,
	SHOTING,
	PASSING,
	HEADER,
	VOLLEY_KICK,
	BICYCLE_KICK,
	CHEST_CONTROL,
	HURT,
	DIVING,
	CELEBRATING,
	MOUMING,
	RESET,
}



@export var ball : Ball
@export var control_scheme : ControlScheme
@export var own_goal : Goal
@export var target_goal : Goal
@export var power : float
@export var speed :float

@onready var ball_detection_area: Area2D = %BallDetectionArea
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var control_sprite: Sprite2D = %ControlSprite
@onready var body: Node2D = $Body
@onready var teammate_deteion: Area2D = %TeammateDeteion
@onready var player_sprite: Sprite2D = %PlayerSprite
@onready var tackle_damage_emitter_area: Area2D = %TackleDamageEmitterArea
@onready var opponent_detection_area: Area2D = %OpponentDetectionArea
@onready var permanent_damage_emitter_area: Area2D = %PermanentDamageEmitterArea
@onready var hands_collider: CollisionShape2D = %HandsCollider
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var power_gpu: GPUParticles2D = %PowerGPU

var current_buff :Array[PlayerBuff]
var ai_behavior_factory := AIBehaviorFactory.new()
var current_ai_behavior : AIBehavior
var country := ""
var current_state: PlayerState = null
var heading := Vector2.RIGHT
var height := 0.0
var height_velocity := 0.0
var kick_position := Vector2.ZERO
var state_factory := PlayerStateFactory.new()
var fullname := ""
var role := Player.Role.MIDFIELD
var skin_color := Player.SkinColor.MEDIUM
var spawn_position := Vector2.ZERO
var weight_on_duty_steering := 0.0
var buff_factory := BuffFactory.new()

func _ready() -> void:
	set_control_texture()
	setup_ai_beheavior()
	switch_state(State.MOVING)
	set_shader_properties()
	permanent_damage_emitter_area.monitoring = role == Role.GOALIE
	hands_collider.disabled = role != Role.GOALIE
	spawn_position = position
	GameEvents.team_scored.connect(on_team_scored.bind())
	GameEvents.game_over.connect(on_game_over.bind())
	var initial_positon := kick_position if country == GameManager.current_match.country_home else spawn_position
	switch_state(State.RESET, PlayerStateData.build().set_reset_position(initial_positon))

func _process(delta: float) -> void:
	flip_body()
	set_sprite_visible()
	process_gravity(delta)
	move_and_slide()
	
		

func set_shader_properties() -> void:
	player_sprite.material.set_shader_parameter("skin_color", skin_color)
	var countries := DataLoader.get_countries()
	var country_color := countries.find(country)
	country_color = clampi(country_color, 0, countries.size() - 1)
	player_sprite.material.set_shader_parameter("team_color", country_color)
	
func initialize(context_position: Vector2, context_ball: Ball, context_own_goal: Goal, context_target_goal: Goal, context_player_data: PlayerResource, context_country: String, context_kick_position: Vector2) -> void:
	position = context_position
	ball = context_ball
	own_goal = context_own_goal
	target_goal = context_target_goal
	speed = context_player_data.speed
	power = context_player_data.power
	role = context_player_data.role
	skin_color = context_player_data.skin_color
	fullname = context_player_data.full_name
	heading = Vector2.LEFT if target_goal.position.x < position.x else Vector2.RIGHT
	country = context_country
	kick_position = context_kick_position

func setup_ai_beheavior() -> void:
	current_ai_behavior = ai_behavior_factory.get_ai_behavior(role)
	current_ai_behavior.set_up(self, ball, opponent_detection_area, teammate_deteion)
	current_ai_behavior.name = "AI Beahavior"
	add_child(current_ai_behavior)

func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.set_up(self, state_data, animation_player, ball,teammate_deteion, ball_detection_area, own_goal, target_goal, current_ai_behavior, tackle_damage_emitter_area)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine: " + str(state)
	call_deferred("add_child", current_state)

func add_buff(buff_index : int) -> void:
	if buff_index == 0:
		add_buff(randi_range(1,4))
		return
	if current_buff.has(buff_factory.get_fresh_buff(buff_index as PlayerBuff.Buff)):
		queue_free_child(current_buff, buff_index)
	current_buff.append(buff_factory.get_fresh_buff(buff_index as PlayerBuff.Buff))
	current_buff[-1].set_up(self)
	current_buff[-1].name = "PlayerBuff:" + str(buff_index)
	call_deferred("add_child", current_buff[-1])
	
func set_movement_animation() -> void:
	var vel_length := velocity.length()
	if vel_length < 1:
		animation_player.play("idle")
	elif vel_length < speed * WALK_ANIM_THRESHOLD:
		animation_player.play("walk")
	else:
		animation_player.play("run")


func process_gravity(delta: float) -> void:
	if height > 0 || height_velocity > 0:
		height_velocity -= GRAVITY * delta
		height += height_velocity
		if height <= 0:
			height = 0
	body.position = Vector2.UP * height

func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT

func face_towards_target_goal() -> void:
	if not is_facing_target_goal():
		heading = heading * -1
		
func flip_body() -> void:
	if heading == Vector2.RIGHT:
		body.scale.x = 1
	elif heading == Vector2.LEFT:
		body.scale.x = -1

func set_sprite_visible() -> void:
	control_sprite.visible = has_ball() || !control_scheme == ControlScheme.CPU
	gpu_particles_2d.emitting = velocity.length() == speed
	
func get_hurt(hurt_origin: Vector2) -> void:
	var data := PlayerStateData.build().set_shot_direction(hurt_origin)
	switch_state(Player.State.HURT, data)

func has_ball() -> bool:
	return ball.carrier == self

func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_MAP[control_scheme]

func set_control_scheme(scheme: ControlScheme) -> void:
	control_scheme = scheme
	set_control_texture()

func get_pass_request(player: Player) -> void:
	if ball.carrier == self && current_state != null && current_state.can_pass():
		switch_state(Player.State.PASSING, PlayerStateData.build().set_pass_target(player))

func on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()

func on_team_scored(team_scored_on: String) -> void:
	if country == team_scored_on:
		switch_state(Player.State.MOUMING)
	else:
		switch_state(Player.State.CELEBRATING)

func on_game_over(winning_team: String) -> void:
	if country == winning_team:
		switch_state(Player.State.CELEBRATING)
	else:
		switch_state(Player.State.MOUMING)

func control_ball() -> void:
	if ball.height > BALL_CONTROL_HEIGHT_MAX:
		switch_state(Player.State.CHEST_CONTROL)
	
func is_facing_target_goal() -> bool:
	var direction_to_target_goal := position.direction_to(target_goal.position)
	return heading.dot(direction_to_target_goal) > 0

func can_carry_ball() -> bool:
	return current_state != null && current_state.can_carry_ball()

func on_tackle_player(player: Player) -> void:
	if player != self && player.country != country && player == ball.carrier:
		player.get_hurt(position.direction_to(player.position))


func _on_buff_detection_area_area_entered(area: Area2D) -> void:
	add_buff(area.buff_index)
	area.queue_free()

func queue_free_child(array: Array, index: int) -> void:
	for i in range(array.size() - 1, -1, -1):
		if array[i].name == "PlayerBuff:" + str(index):
			remove_child(array[i])
			array.remove_at(i)
