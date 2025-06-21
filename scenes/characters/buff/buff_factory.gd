extends Node2D

const BUFF := preload("res://scenes/characters/buff/buff_area.tscn")
const MAX_SIMULTANEOUS_VALUE :int= 3
const DURATION_BETWEEN_SPAWN_BUFF :int = 5000

var is_active:bool = false
var is_maximum:bool = false
var time_since_last_spawn_buff:int

func _enter_tree() -> void:
	time_since_last_spawn_buff = Time.get_ticks_msec()
	if GameEvents.setting_varrent[3] == 1:
		is_active = true

func _process(delta: float) -> void:
	if is_active && Time.get_ticks_msec() - time_since_last_spawn_buff > DURATION_BETWEEN_SPAWN_BUFF && not is_maximum && GameManager.get_child(0).name.ends_with("0"):
		spawn_buff()
		time_since_last_spawn_buff = Time.get_ticks_msec()

func spawn_buff() -> void:
	var buff := BUFF.instantiate()
	var rect :Rect2i = Rect2i(117, 85, 590, 223)
	var random_position = get_random_point_in_rect(rect)
	buff.position = random_position
	add_child(buff)
	if get_child_count() == MAX_SIMULTANEOUS_VALUE:
		is_maximum = true
	
	

func get_random_point_in_rect(rect: Rect2i) -> Vector2:
	var x = randf_range(rect.position.x, rect.end.x)
	var y = randf_range(rect.position.y, rect.end.y)
	return Vector2(x,y)
