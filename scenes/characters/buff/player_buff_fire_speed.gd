class_name PlayerFireSpeed
extends PlayerBuff

var current_speed 

func _enter_tree() -> void:
	current_speed = player.speed
	player.speed = player.speed * 2
	player.gpu_particles_2d.modulate = Color(0.862745, 0.0784314, 0.235294, 1)

func _exit_tree() -> void:
	player.speed = current_speed
	player.gpu_particles_2d.modulate = Color(1, 1, 1, 1)
	
