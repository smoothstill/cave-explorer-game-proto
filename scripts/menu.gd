extends Control


var is_paused = false setget set_is_paused
var is_game_running = true setget set_is_game_running
onready var start_button = $Background/VBoxContainer/Start
onready var quit_button = $Background/VBoxContainer/Quit
onready var main_menu_button = $Background/VBoxContainer/MainMenu

func _ready():
	var is_running = isGameRunning()
	set_is_game_running(is_running)
	if !is_running:
		main_menu_button.visible = false
	print("game is running ", is_game_running)
	start_button.grab_focus()
	pass
	
# Check if the game is running or we are in the main menu
func isGameRunning() -> bool:
	return !get_tree().current_scene.name == "MainMenu"
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		# If game is not paused, pause the game
		if !is_paused:
			set_is_paused(true)
		# If game is currently running and paused, resume the game
		elif is_paused and is_game_running:
			set_is_paused(false)
		
func _on_Start_pressed():
	#TODO: get_tree().change_scene("scenename")
	# If game is currently running and paused, resume the game
	if is_paused and is_game_running:
		set_is_paused(false)

func set_is_paused(value):
	is_paused = value
	get_tree().paused = value
	visible = is_paused
	if is_paused:
		start_button.grab_focus()
	
	if is_game_running: 
		start_button.text = "Resume game"
	else:
		start_button.text = "Start game"
	
func set_is_game_running(value):
	is_game_running = value
	# Change "Start game" to "Resume game" when game is running
	if !value: 
		start_button.text = "Resume game"
		print("sd")
	else:
		start_button.text = "Start game"
		print("sd")

# Quit the game
func _on_Quit_pressed():
	get_tree().quit()


func _on_MainMenu_pressed():
	#To main menu scene
	pass
