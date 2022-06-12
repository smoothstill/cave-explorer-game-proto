extends Control

onready var start_button = $CanvasLayer/Background/VBoxContainer/Start

func _ready():
	start_button.grab_focus()

func _on_Start_pressed():
	GameStateManager.set_state(GameStateManager.states.GAMEPLAY)

func _on_Quit_pressed():
	get_tree().quit()
