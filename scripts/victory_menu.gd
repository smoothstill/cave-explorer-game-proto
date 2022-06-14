extends Control

onready var _menu_button = $CanvasLayer/Background/VBoxContainer/Menu

func _ready():
	_menu_button.grab_focus()

func _on_Menu_pressed():
	GameStateManager.set_state(GameStateManager.states.MAINMENU)

func _on_Quit_pressed():
	get_tree().quit()
