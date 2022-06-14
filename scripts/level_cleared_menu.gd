extends Control

var _disabled = true setget _set_disabled
onready var _menu = $CanvasLayer/Background
onready var _continue_button = $CanvasLayer/Background/VBoxContainer/Continue
onready var _label = $CanvasLayer/Background/VBoxContainer/Label

func _ready():
	var node = get_tree().get_root().find_node("FinishArea", true, false)
	node.connect("level_clear", self, "_on_level_cleared")
	_set_disabled(true)

func _set_disabled(value):
	if (value == true):
		_menu.visible = false
		_disabled = true
		get_tree().paused = false
	else:
		_menu.visible = true
		_disabled = false
		get_tree().paused = true
		_continue_button.grab_focus()

func _on_level_cleared():
	if LevelManager.get_level_state() != LevelManager.states.STOPPED:
		_label.text = "Level " + str(LevelManager.get_level_id() + 1) + " cleared!"
		LevelManager.set_level_state(LevelManager.states.STOPPED)
		_set_disabled(false)

func _on_Continue_pressed():
	if LevelManager.has_next_level():
		LevelManager.to_next_level()
	else:
		GameStateManager.set_state(GameStateManager.states.VICTORY)

func _on_Quit_pressed():
	get_tree().quit()

func _on_Menu_pressed():
	GameStateManager.set_state(GameStateManager.states.MAINMENU)
