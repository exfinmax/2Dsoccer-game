class_name PlayerBuff
extends Node

var duration_time :int

func _enter_tree() -> void:
	pass

func _process(delta: float) -> void:
	if duration_time - delta < 0:
		queue_free()

func _exit_tree() -> void:
	pass
