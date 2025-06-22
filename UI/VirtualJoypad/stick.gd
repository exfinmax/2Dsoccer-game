extends Control


@onready var knob: TouchScreenButton = $Knob
@onready var options_actions: Node2D = $OptionsActions

func _init() -> void:
	GameEvents.control_change.connect(on_option_change.bind())
	

func on_option_change(is_active:bool) -> void:
	if is_active:
		knob.visible = false
		options_actions.visible = true
	else:
		knob.visible = true
		options_actions.visible = false
