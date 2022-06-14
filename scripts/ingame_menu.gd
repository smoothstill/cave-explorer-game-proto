extends Control

onready var _continue_button = $CanvasLayer/Background/VBoxContainer/Continue
onready var _menu = $CanvasLayer/Background
var _disabled = true setget _set_disabled

func _ready():
	_set_disabled(true)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		_set_disabled(!_disabled)

func _set_disabled(value):
	# Shouldn't exist outside gameplay
	if GameStateManager.get_state() == GameStateManager.states.GAMEPLAY and LevelManager.get_level_state() != LevelManager.states.STOPPED:
		if value == false:
			LevelManager.set_level_state(LevelManager.states.PAUSED)
			_menu.visible = true
			_disabled = false
			_continue_button.grab_focus()
		else:
			LevelManager.set_level_state(LevelManager.states.RUNNING)
			_menu.visible = false
			_disabled = true
	else:
		print("WARNING: Cannot activate in-game menu right now")

func _on_Continue_pressed():
	_set_disabled(true)

func _on_Menu_pressed():
	GameStateManager.set_state(GameStateManager.states.MAINMENU)

func _on_Quit_pressed():
	get_tree().quit()
