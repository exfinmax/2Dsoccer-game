extends TouchScreenButton

const DRAG_RADIUS := 10.0

@onready var rest_pos := global_position
@onready var sprite_2d: Sprite2D = $"../Sprite2D"

var finger_index := -1
var drag_offset: Vector2

func _input(event: InputEvent) -> void:
	var st := event as InputEventScreenTouch
	if st:
		if st.pressed && finger_index == -1:
			var global_pos := st.position * get_canvas_transform()
			var local_pos := global_pos * get_global_transform()
			var rect := Rect2i(24,128,34,36)
			if rect.has_point(global_pos):
				finger_index = st.index
				drag_offset = global_pos - global_position
		elif !st.pressed && st.index == finger_index:
			sprite_2d.visible = false
			Input.action_release("p1_left")
			Input.action_release("p1_right")
			Input.action_release("p1_up")
			Input.action_release("p1_down")
			finger_index = -1
			global_position = rest_pos
	
	var sd := event as InputEventScreenDrag
	if sd && sd.index == finger_index:
		sprite_2d.visible = true
		var wish_pos := sd.position * get_canvas_transform() - drag_offset
		var movement := (wish_pos - rest_pos).limit_length(DRAG_RADIUS)
		global_position = rest_pos + movement
		
		movement /= DRAG_RADIUS
		if movement.x > 0:
			Input.action_release("p1_left")
			Input.action_press("p1_right", (movement.x/2 + 0.5))
		elif movement.x < 0:
			Input.action_release("p1_right")
			Input.action_press("p1_left", (-movement.x/2 + 0.5))
		if movement.y > 0:
			Input.action_release("p1_up")
			Input.action_press("p1_down", (movement.y/2 + 0.5))
		elif movement.y < 0:
			Input.action_release("p1_down")
			Input.action_press("p1_up", (-movement.y/2 + 0.5))
