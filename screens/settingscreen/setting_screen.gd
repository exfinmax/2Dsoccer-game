class_name SettingScreen
extends Screen


@onready var settingthings: VBoxContainer = %Settingthings

var active_containers :Array
var current_index : int = 0
var current_active_container : ActiveContainer
var ready_index : int = 0

func _ready() -> void:
	for node in settingthings.get_children():
		if node is ActiveContainer:
			node.current_value = GameEvents.setting_varrent[ready_index]
			active_containers.append(node)
			ready_index += 1
	GameEvents.setting_varrent = []
	refresh_ui()

func refresh_ui() -> void:
	for i in active_containers.size():
		if i == current_index:
			active_containers[i].is_active = true
			current_active_container = active_containers[i]
		else:
			active_containers[i].is_active = false
		active_containers[i].refresh_ui()
		

func _process(delta: float) -> void:
	if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.UP):
		current_index = clampi(current_index - 1, 0, active_containers.size() - 1)
		refresh_ui()
		SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
	elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.DOWN):
		current_index = clampi(current_index + 1, 0, active_containers.size() - 1)
		refresh_ui()
		SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
	elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.LEFT):
		current_active_container.current_value = clampi(current_active_container.current_value - 1, current_active_container.min_value, current_active_container.max_value)
		SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
	elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.RIGHT):
		current_active_container.current_value = clampi(current_active_container.current_value + 1, current_active_container.min_value, current_active_container.max_value)
		SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
	elif Input.is_action_just_pressed("set"):
		transition_state(SoccerGame.ScreenType.MAIN_MENU)

func _exit_tree() -> void:
	for i in active_containers.size():
		GameEvents.setting_varrent.append(active_containers[i].current_value)
	GameEvents.set_change.emit()
