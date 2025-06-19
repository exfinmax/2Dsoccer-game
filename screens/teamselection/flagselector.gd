class_name FlagSelector
extends Control

signal selected

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var indecator_1p: TextureRect = %Indecator1P
@onready var indecator_2p: TextureRect = %Indecator2P

var control_scheme := Player.ControlScheme.P1
var is_selected := false

func _ready() -> void:
	indecator_1p.visible = control_scheme == Player.ControlScheme.P1
	indecator_2p.visible = control_scheme == Player.ControlScheme.P2

func _physics_process(_delta: float) -> void:
	if not is_selected && KeyUtils.is_action_just_pressed(control_scheme, KeyUtils.Action.SHOOT):
		is_selected = true
		animation_player.play("seleted")
		SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)
		selected.emit()
	elif is_selected && KeyUtils.is_action_just_pressed(control_scheme, KeyUtils.Action.PASS):
		is_selected = false
		animation_player.play("selecting")
