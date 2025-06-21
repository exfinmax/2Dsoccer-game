class_name MainMenuScreen
extends Screen

const MENU_TEXTURES := [
	[preload("res://assets/art/ui/mainmenu/1-player.png"),preload("res://assets/art/ui/mainmenu/1-player-selected.png")],
	[preload("res://assets/art/ui/mainmenu/2-players.png"), preload("res://assets/art/ui/mainmenu/2-players-selected.png")],
]

@onready var selectable_menu_nodes : Array[TextureRect] = [%SingalPlayerTexture, %TwoPlayerTexture]
@onready var select_icon: TextureRect = %SelectIcon

var is_acitve := false
var current_selected_index := 0

func _ready() -> void:
	refresh_ui()

func _process(delta: float) -> void:
	if is_acitve:
		if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.UP):
			change_selected_index(current_selected_index - 1)
		elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.DOWN):
			change_selected_index(current_selected_index + 1)
		elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.SHOOT):
			submit_selection()
		elif Input.is_action_just_pressed("set"):
			transition_state(SoccerGame.ScreenType.SETTING)
			
	
func refresh_ui() -> void:
	for i in selectable_menu_nodes.size():
		if current_selected_index == i:
			selectable_menu_nodes[i].texture = MENU_TEXTURES[i][1]
			select_icon.position = selectable_menu_nodes[i].position + Vector2.LEFT * 25
		else:
			selectable_menu_nodes[i].texture = MENU_TEXTURES[i][0]

func change_selected_index(new_index) -> void:
	current_selected_index = clampi(new_index, 0, selectable_menu_nodes.size() - 1)
	SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
	refresh_ui()
	
func submit_selection() -> void:
	SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)
	var country_default := DataLoader.get_countries()[1]
	var player_two = "" if current_selected_index == 0 else country_default
	GameManager.player_setup = [country_default, player_two]
	transition_state(SoccerGame.ScreenType.TEAM_SELECTION)
	
func on_set_active() -> void:
	refresh_ui()
	is_acitve = true
