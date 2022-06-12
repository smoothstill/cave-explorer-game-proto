extends Control

onready var retry_button = $CanvasLayer/Background/VBoxContainer/Retry
onready var label = $CanvasLayer/Background/VBoxContainer/Label
onready var menu = $CanvasLayer/Background
var disabled = false setget _set_disabled

func _set_disabled(value):
	# Shouldn't exist outside gameplay
	if GameStateManager.get_state() == GameStateManager.states.GAMEPLAY:
		if value == true:
			print("visible = false")
			menu.visible = false
			disabled = true
		else:
			retry_button.grab_focus()
			menu.visible = true
			disabled = false
		
		# If player has no lives left, disable continue button
		if Lives.player_lives == 0:
			retry_button.visible = false
			label.text = "GAME OVER!"
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
	_set_disabled(false)

func _on_Retry_pressed():
	# Restart level
	if !disabled:
		get_tree().reload_current_scene()

func _on_Menu_pressed():
	if !disabled:
		GameStateManager.set_state(GameStateManager.states.MAINMENU)

func _on_Quit_pressed():
	# Quit game
	if !disabled:
		get_tree().quit()
