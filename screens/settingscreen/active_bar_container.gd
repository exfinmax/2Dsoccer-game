extends ActiveContainer

@onready var h_box_container: HBoxContainer = %HBoxContainer

func _ready() -> void:
	super._ready()
	refresh_ui()
	
	

func _process(delta: float) -> void:
	if is_active:
		refresh_ui()

func refresh_ui() -> void:
	super.refresh_ui()
	for i in range(min_value, current_value):
		h_box_container.get_child(i).modulate = color_actived
	for i in range(current_value, max_value):
		h_box_container.get_child(i).modulate = color_default
