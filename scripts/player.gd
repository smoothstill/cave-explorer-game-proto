extends KinematicBody2D

signal fuel_updated(fuel_amount)
signal killed()

var horizontal_acceleration:= 0.5
var jetpack_acceleration := 2
var velocity := Vector2(0.0, 0.0)
var gravity := 0.9
var bounce_coefficent = 1.0
export var max_fuel := 100.0
onready var fuel_amount = max_fuel setget _set_fuel
var fuel_decrease_speed := 2
onready var invulnerability_timer = $InvulnerabilityTimer

func on_killed():
	pass

func _set_fuel(value):
	var prev_fuel = fuel_amount
	fuel_amount = clamp(value, 0, max_fuel)
	if fuel_amount != prev_fuel:
		emit_signal("fuel_updated", fuel_amount)
		if fuel_amount == 0:
			emit_signal("killed")
			on_killed()
			
func damageFuel(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_fuel(fuel_amount - amount)
		
func reduceFuel(amount):
	_set_fuel(fuel_amount - amount)
		
func addFuel(amount):
	_set_fuel(fuel_amount + amount)
		
func _process(delta):
	var vertical_speed = 0
	var horizontal_speed = 0
	if Input.is_action_pressed("jump"):
		vertical_speed -= delta * jetpack_acceleration
		reduceFuel(delta*fuel_decrease_speed)
	vertical_speed += delta * gravity # Gravity
	horizontal_speed += delta * horizontal_acceleration
	velocity += Vector2(horizontal_speed, vertical_speed)
	var collision = move_and_collide(velocity)
	if collision != null:
		# Damage taken is based on impact velocity
		var damage_taken = 10 * pow(velocity.length(), 1.7)
		var motion = collision.normal.reflect(collision.remainder.normalized())
		velocity = collision.normal.reflect(velocity.normalized())*bounce_coefficent
		velocity.x = -velocity.x
		damageFuel(damage_taken)
		move_and_collide(motion)
