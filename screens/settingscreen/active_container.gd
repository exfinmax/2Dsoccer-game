class_name ActiveContainer
extends HBoxContainer

@onready var label: Label = $Label

@export var text : String
@export var color_default : Color
@export var color_actived : Color
@export var current_value : int
@export var max_value : int
@export var min_value : int


var is_active: bool = false

func _ready() -> void:
	label.text = text

func refresh_ui() -> void:
	if is_active:
		label.modulate = color_actived
	else:
		label.modulate = color_default
