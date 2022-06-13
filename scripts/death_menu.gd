extends Control

onready var retry_button = $CanvasLayer/Background/VBoxContainer/Retry
onready var menu_button = $CanvasLayer/Background/VBoxContainer/Menu
onready var label = $CanvasLayer/Background/VBoxContainer/Label
onready var menu = $CanvasLayer/Background
var disabled = false setget _set_disabled

func _set_disabled(value):
	# Shouldn't exist outside gameplay
	if GameStateManager.get_state() == GameStateManager.states.GAMEPLAY:
		if value == true:
			menu.visible = false
			disabled = true
		else:
			retry_button.grab_focus()
			menu.visible = true
			disabled = false
		
		# If player has no lives left, disable continue button
		if Lives.player_lives == 0:
			retry_button.visible = false
			menu_button.grab_focus()
			label.text = "Game over"
		else:
			retry_button.visible = true
			label.text = "You died! Lives: " + str(Lives.player_lives)
	else:
		print("ERROR: DeathMenu shouldn't exits outside gameplay!")
		

func _ready():
	# Disabled on default
	_set_disabled(true)
	
	# Connect to signal killed(lives)
	var playernode = get_tree().get_root().find_node("Player", true, false)
	playernode.connect("killed", self, "_on_player_killed")

func _on_player_killed(lives):
	if (LevelManager.current_state != LevelManager.states.STOPPED):
		LevelManager.set_level_state(LevelManager.states.STOPPED)
		_set_disabled(false)

func _on_Retry_pressed():
	# Restart level
	LevelManager.restart_level()

func _on_Menu_pressed():
	if !disabled:
		GameStateManager.set_state(GameStateManager.states.MAINMENU)

func _on_Quit_pressed():
	# Quit game
	get_tree().quit()
