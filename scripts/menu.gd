extends Control


var is_paused = false setget set_is_paused
var is_game_running = true setget set_is_game_running

func _ready():
	#$Background/VBoxContainer/Start.grab_focus()
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		# If game is not paused, pause the game
		if !is_paused:
			set_is_paused(true)
		# If game is currently running and paused, resume the game
		elif is_paused and is_game_running:
			set_is_paused(false)
		
func _on_Start_pressed():
	#get_tree().change_scene("scenename")
	# If game is currently running and paused, resume the game
	if is_paused and is_game_running:
		set_is_paused(false)

func set_is_paused(value):
	is_paused = value
	get_tree().paused = value
	visible = is_paused
	
func set_is_game_running(value):
	is_game_running = value
	get_tree().is_game_running = value
	# Change "Start game" to "Resume game" when game is running
	if !value: 
		#$Background/VBoxContainer/Start.text = "Resume game"
		print("sd")
	else:
		#$Background/VBoxContainer/Start.text = "Start game"
		print("sd")

# Quit the game
func _on_Quit_pressed():
	get_tree().quit()
