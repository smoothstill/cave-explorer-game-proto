extends Node

# This script manages state of the game
enum states {MAINMENU, GAMEPLAY, VICTORY}

# Start the game in main menu
var _current_state = states.MAINMENU setget set_state, get_state

# Set the state of the game
func set_state(state):
	# Do nothing is state does not change
	if state == _current_state:
		print("Warning: State did not change! ", state)
		return
	_entered(state)
	
func get_state():
	return _current_state

# Actions to do when entering a new state
func _entered(state):
	if state == states.MAINMENU:
		_current_state = state
		get_tree().change_scene("res://scenes/MainMenu.tscn")
		return
	elif state == states.GAMEPLAY:
		_current_state = state
		Lives.player_lives = 3
		LevelManager.load_first_level()
		return
	elif state == states.VICTORY:
		_current_state = state
		get_tree().change_scene("res://scenes/VictoryMenu.tscn")
		return
	else:
		print("ERROR: Invalid game state ", state)
