extends KinematicBody2D

signal fuel_updated(fuel_amount)
signal killed()

var max_vertical_speed := 10000
var min_vertical_speed := -10000
var max_horizontal_speed := 300
var horizontal_acceleration:= 800
var jetpack_acceleration := 9
var vertical_speed := 0.0
var horizontal_speed := 0.0
var gravity := 5
export var max_fuel := 100.0
onready var fuel_amount = max_fuel setget _set_fuel
var fuel_decrease_speed := 0.02

func _set_fuel(value):
	var prev_fuel = fuel_amount
	fuel_amount = clamp(value, 0, max_fuel)
	if fuel_amount != prev_fuel:
		emit_signal("fuel_updated", fuel_amount)
		# print("fuel_amount", fuel_amount)
		# if fuel_amount == 0:	
		# kill() 
		
func _process(delta):
		_horizontal_movement(delta)
		_vertical_movement(delta)

# Checks Jump and applies gravity and vertical speed via move_and_collide.
func _vertical_movement(delta):
	var localUp = Vector2.UP
	if Input.is_action_pressed("jump"):
		vertical_speed += delta * jetpack_acceleration
		_set_fuel(fuel_amount - fuel_decrease_speed)
	vertical_speed -= delta * gravity # Gravity
	if vertical_speed < min_vertical_speed:
		vertical_speed = min_vertical_speed
	if vertical_speed > max_vertical_speed:
		vertical_speed = max_vertical_speed
	var k = move_and_collide(localUp * vertical_speed)
	if k != null:
		print(k.normal)
		vertical_speed = 0

# Checks WASD and Shift for horizontal movement via move_and_slide.
func _horizontal_movement(delta):
	var localRight = Vector2.RIGHT
	horizontal_speed += delta * horizontal_acceleration
	if (horizontal_speed > max_horizontal_speed):
		horizontal_speed = max_horizontal_speed
	move_and_slide(localRight * horizontal_speed)
