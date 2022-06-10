extends Control

onready var retry_button = $Background/VBoxContainer/Retry
onready var main_menu_button = $Background/VBoxContainer/MainMenu
onready var quit_button = $Background/VBoxContainer/Quit

# Player has lost all lives
var player_lost = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	var playernode = get_tree().get_root().find_node("Player", true, false)
	playernode.connect("killed", self, "_on_player_killed")

func _on_player_killed(lives):
	print("lives are ", lives)
	if lives == 0:
		player_lost = true
		retry_button.visible = false
		main_menu_button.grab_focus()
	else:
		retry_button.grab_focus()
	visible = true

func _on_Retry_pressed():
	if !player_lost:
		print("restart level")
		get_tree().reload_current_scene()
		# Restart level

func _on_MainMenu_pressed():
	# To main menu level
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()
