extends Control

onready var _lives = $CanvasLayer/Lives

# Called when the node enters the scene tree for the first time.
func _ready():
	_lives.text = "Lives: " + str(Lives.player_lives)
	
	# Connect to signal killed(remaining_lives)
	var playernode = get_tree().get_root().find_node("Player", true, false)
	playernode.connect("killed", self, "_on_player_killed")

func _on_player_killed(remaining_lives):
	_lives.text = "Lives: " + str(remaining_lives)
