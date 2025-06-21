extends Area2D

@onready var Buffsprite: Sprite2D = $BuffSprite

@export var max_value :int

var buff_index : int

func _enter_tree() -> void:
	buff_index = randi_range(0, max_value)
