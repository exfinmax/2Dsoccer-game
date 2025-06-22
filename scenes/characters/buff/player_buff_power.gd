class_name PlayerPower
extends PlayerBuff

var current_power

func _enter_tree() -> void:
	duration_time = 20
	current_power = player.power
	player.power = current_power * 1.5
	player.power_gpu.emitting = true
	
func _exit_tree() -> void:
	player.power = current_power
	player.power_gpu.emitting = false
	player.power_gpu.emitting = false
