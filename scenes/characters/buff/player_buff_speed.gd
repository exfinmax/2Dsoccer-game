class_name PlayerSpeed
extends PlayerBuff

var current_speed

func _enter_tree() -> void:
	current_speed = player.speed
	player.gpu_particles_2d.modulate = Color(0, 0.972549, 1, 1)
	player.speed = player.speed * 1.5



func _exit_tree() -> void:
	player.speed = current_speed
	player.gpu_particles_2d.modulate = Color(1,1,1,1)
