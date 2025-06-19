class_name TeamSelectionScreen
extends Screen

const FLAG_POINT := Vector2(35, 80)
const FLAG_SELETOR := preload("res://screens/teamselection/flagselector.tscn") 
const NB_COLS := 4
const NB_ROWS := 2

@onready var flag_container: Control = $Background/FlagContainer

var selection : Array[Vector2i] = [Vector2i.ZERO, Vector2i.ZERO]
var selectors : Array[FlagSelector] = []

func _ready() -> void:
	place_flag()
	place_selectors()

func _process(_delta: float) -> void:
	for i in range(selectors.size()):
		var selector := selectors[i]
		if not selector.is_selected:
			if KeyUtils.is_action_just_pressed(selector.control_scheme, KeyUtils.Action.RIGHT):
				try_navigate(i, Vector2i.RIGHT)
			elif KeyUtils.is_action_just_pressed(selector.control_scheme, KeyUtils.Action.LEFT):
				try_navigate(i, Vector2i.LEFT)
			elif KeyUtils.is_action_just_pressed(selector.control_scheme, KeyUtils.Action.UP):
				try_navigate(i, Vector2i.UP)
			elif KeyUtils.is_action_just_pressed(selector.control_scheme, KeyUtils.Action.DOWN):
				try_navigate(i, Vector2i.DOWN)
	if not selectors[0].is_selected && KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.PASS):
		SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
		transition_state(SoccerGame.ScreenType.MAIN_MENU)
		
func try_navigate(selector_index:int , direction: Vector2i) -> void:
	var rect : Rect2i = Rect2i(0 , 0, NB_COLS, NB_ROWS)
	if rect.has_point(selection[selector_index] + direction):
		selection[selector_index] += direction
		var flag_index := selection[selector_index].x + selection[selector_index].y * NB_COLS
		GameManager.player_setup[selector_index] = DataLoader.get_countries()[1 + flag_index]
		selectors[selector_index].position = flag_container.get_child(flag_index).position
		SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
		
func place_flag() -> void:
	for j in range(NB_ROWS):
		for i in range(NB_COLS):
			var flag_texture := TextureRect.new()
			flag_texture.position = FLAG_POINT + Vector2(55 * i, 50 * j)
			var country_index := 1 + i + NB_COLS * j
			var country := DataLoader.get_countries()[country_index]
			flag_texture.texture = TextureHelper.get_texture(country)
			flag_texture.scale = Vector2(2,2)
			flag_texture.z_index = 1
			flag_container.add_child(flag_texture)

func place_selectors() -> void:
	add_seletor(Player.ControlScheme.P1)
	if not GameManager.player_setup[1].is_empty():
		add_seletor(Player.ControlScheme.P2)

func add_seletor(control_scheme: Player.ControlScheme) -> void:
	var seletor := FLAG_SELETOR.instantiate()
	seletor.position = flag_container.get_child(0).position
	seletor.control_scheme = control_scheme
	seletor.selected.connect(on_selector_selected.bind())
	selectors.append(seletor)
	flag_container.add_child(seletor)

func on_selector_selected() -> void:
	for selector in selectors:
		if not selector.is_selected:
			return
	var country_p1 := GameManager.player_setup[0]
	var country_p2 := GameManager.player_setup[1]
	if not country_p2.is_empty() && country_p1 != country_p2:
		GameManager.countries = [country_p2, country_p1]
		transition_state(SoccerGame.ScreenType.IN_GAME)
