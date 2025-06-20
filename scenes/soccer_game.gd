class_name SoccerGame
extends Node

enum ScreenType {
	MAIN_MENU,
	TEAM_SELECTION,
	TOURNAMENT,
	IN_GAME,
	SETTING,
}

var current_screen : Screen = null
var screen_factory := Screenfactory.new()

func _init() -> void:
	switch_screen(ScreenType.MAIN_MENU)


func switch_screen(screen: ScreenType, data:ScreenData = ScreenData.new()) -> void:
	if current_screen != null:
		current_screen.queue_free()
	current_screen = screen_factory.get_fresh_state(screen)
	current_screen.set_up(self, data)
	current_screen.state_transition_requested.connect(switch_screen.bind())
	call_deferred("add_child", current_screen)
