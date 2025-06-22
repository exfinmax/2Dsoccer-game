class_name PlayerBuff
extends Node

enum Buff{
	RANDOM,
	FIRE_SPEED,
	POWER,
	SPEED,
	SUSPICIOUS,
}
var current_delta :float
var duration_time :int = 8
var player_speed :float
var player : Player = null

func _enter_tree() -> void:
	pass

func _process(delta: float) -> void:
	current_delta += delta
	if duration_time - current_delta < 0:
		queue_free()

func set_up(context_player: Player) -> void:
	player = context_player

func _exit_tree() -> void:
	pass
