extends Control


var is_paused = false setget set_is_paused
var is_game_running = true setget set_is_game_running
var disabled = false setget set_disabled
onready var start_button = $Background/VBoxContainer/Start
onready var quit_button = $Background/VBoxContainer/Quit
onready var main_menu_button = $Background/VBoxContainer/MainMenu

func _ready():
	var is_running = is_game_running()
	set_is_game_running(is_running)
	if !is_running:
		main_menu_button.visible = false
	start_button.grab_focus()
	
	var playernode = get_tree().get_root().find_node("Player", true, false)
	playernode.connect("killed", self, "_on_player_killed")
	
# Check if the game is running or we are in the main menu
func is_game_running() -> bool:
	return !get_tree().current_scene.name == "MainMenu"

# When player dies, disable this menu
func _on_player_killed(lives):
	set_disabled(true)

# Disable and hide menu (e.g. when player dies)
func set_disabled(value):
	disabled = value
	visible = !value
	
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
	if !disabled and is_paused and is_game_running:
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
	if !disabled:
		get_tree().quit()


func _on_MainMenu_pressed():
	if !disabled:
		print("To main menu")
