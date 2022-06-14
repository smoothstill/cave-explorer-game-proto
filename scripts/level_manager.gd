extends Node

var _current_level = 0 setget , get_level_id

enum states {RUNNING, PAUSED, STOPPED}
var _current_state = 0 setget set_level_state , get_level_state

# Level scenes
var levels = ["res://scenes/Levels/Level1.tscn", "res://scenes/Levels/Level2.tscn"]

func get_level_state():
	return _current_state

func get_level_id():
	return _current_level

func set_level_state(state):
	var previous_state = _current_state
	if (state == previous_state):
		print("WARNING: Level state did not change!")
		return
	_entered(state)

func _entered(state):
	if state == states.PAUSED:
		get_tree().paused = true
		_current_state = state
	elif state == states.RUNNING:
		get_tree().paused = false
		_current_state = state
	elif state == states.STOPPED:
		_current_state = state
	else:
		print("ERROR: Invalid level state: ", state)

func load_first_level():
	_current_level = 0
	_current_state = states.RUNNING
	get_tree().change_scene(levels[0])
	
func has_next_level():
	return levels.size() > _current_level + 1

func to_next_level():
	_current_level += 1
	_current_state = states.RUNNING
	get_tree().change_scene(levels[_current_level])
	
func restart_level():
	_current_state = states.RUNNING
	get_tree().reload_current_scene()
