extends Control

var disabled = true setget _set_disabled
onready var menu = $CanvasLayer/Background
onready var continue_button = $CanvasLayer/Background/VBoxContainer/Continue
onready var label = $CanvasLayer/Background/VBoxContainer/Label

func _ready():
	var node = get_tree().get_root().find_node("FinishArea", true, false)
	print(node)
	node.connect("level_clear", self, "_on_level_cleared")
	_set_disabled(true)

func _set_disabled(value):
	if (value == true):
		menu.visible = false
		disabled = true
		get_tree().paused = false
	else:
		menu.visible = true
		disabled = false
		get_tree().paused = true
		continue_button.grab_focus()

func _on_level_cleared():
	label.text = "Level " + str(LevelManager.current_level + 1) + " cleared!"
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
