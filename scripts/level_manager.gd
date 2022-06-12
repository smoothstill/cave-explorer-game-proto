extends Node

var current_level = 0 setget , get_level_id

enum states {RUNNING, PAUSED, STOPPED}
var current_state = 0 setget set_level_state , get_level_state

# Level scenes
var levels = ["res://scenes/Levels/Level1.tscn"]

func get_level_state():
	return current_state

func get_level_id():
	return current_level

func set_level_state(state):
	var previous_state = current_state
	if (state == previous_state):
		print("WARNING: No level state changed!")
		return
	_entered(state)

func _entered(state):
	if state == states.PAUSED:
		get_tree().paused = true
		current_state = state
	elif state == states.RUNNING:
		get_tree().paused = false
		current_state = state
	elif state == states.STOPPED:
		current_state = state
	else:
		print("ERROR: Invalid level state: ", state)

func load_first_level():
	current_level = 0
	current_state = states.RUNNING
	get_tree().change_scene(levels[0])
	
func has_next_level():
	return levels.size() > current_level + 1

func to_next_level():
	current_level += 1
	current_state = states.RUNNING
	get_tree().change_scene(levels[current_level])
	
func restart_level():
	current_state = states.RUNNING
	get_tree().reload_current_scene()
