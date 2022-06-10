extends Node

# This script manages state of the game
enum states {MAINMENU, GAMEPLAY, VICTORY}

# Start the game in main menu
var current_state = states.MAINMENU setget _set_state

# Set the state of the game
func _set_state(state):
	# Do nothing is state does not change
	if state == current_state:
		print("Error: State did not change! ", state)
		return
	var previous_state = current_state
	current_state = state
	leaving(previous_state)
	entered(current_state)

# Actions to do when entering a new state
func entered(state):
	if state == states.MAINMENU:
		# TODO: Enter the main menu
		return
	elif state == states.GAMEPLAY:
		# Set player lives
		Lives.player_lives = 3
		# TODO: Enter the first level
		return
	elif state == states.VICTORY:
		# TODO: Enter the victory screen
		return

# Not used for now	
func leaving(state):
	if state == states.MAINMENU:
		return
	elif state == states.GAMEPLAY:
		return
	elif state == states.VICTORY:
		return
