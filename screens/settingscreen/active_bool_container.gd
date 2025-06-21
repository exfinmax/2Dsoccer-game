extends ActiveContainer

@onready var bool_label: Label = $BoolLabel


func _ready() -> void:
	super._ready()
	refresh_ui()
	
func _process(delta: float) -> void:
	if is_active:
		refresh_ui()
		

func refresh_ui() -> void:
	super.refresh_ui()
	bool_label.text = "OFF" if current_value == 0 else "ON"
	bool_label.modulate = color_default if bool_label.text == "OFF" else color_actived
	
