extends Area2D

const BUFF_ICON :Dictionary = {
	0 : preload("res://assets/art/buff_icon/bowling-propulsion.png"),
	1 : preload("res://assets/art/buff_icon/fire-dash.png"),
	2 : preload("res://assets/art/buff_icon/mighty-force.png"),
	3 : preload("res://assets/art/buff_icon/sprint.png"),
	4 : preload("res://assets/art/buff_icon/suspicious.png"),
}
const DURATION_TIME := 6

@onready var Buffsprite: Sprite2D = $BuffSprite

@export var max_value :int

var current_delta : float
var buff_index : int
var time_since_spawn 

func _ready() -> void:
	buff_index = randi_range(0, max_value)
	Buffsprite.texture = BUFF_ICON[buff_index]
	time_since_spawn = Time.get_ticks_msec()
	
func _process(delta: float) -> void:
	current_delta += delta
	modulate.a = 1 + 0.5*sin(current_delta)
	if DURATION_TIME - current_delta < 0:
		queue_free()
