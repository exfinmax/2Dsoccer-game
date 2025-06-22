extends Control

@onready var options: TouchScreenButton = $Options

func _ready() -> void:
	GameEvents.menu.connect(on_menu_change.bind())

func on_menu_change(is_active:bool) -> void:
	if is_active:
		options.visible = true
	else:
		options.visible = false
