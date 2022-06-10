extends Node

var current_level = 0 setget , _get_level

# Level scenes
var levels = {}

func _get_level():
	return current_level

func load_level(level_number):
	pass

func to_next_level():
	pass
	
func restart_level():
	pass
	
func pause_level():
	pass
