extends KinematicBody2D

signal fuel_updated(fuel_amount)
signal killed(lives)

var horizontal_acceleration:= 1.0
var jetpack_acceleration := 15
var velocity := Vector2(0.0, 0.0)
var gravity := 5
var bounce_coefficent = 1.0
export var max_fuel := 100.0
onready var fuel_amount = max_fuel setget _set_fuel
var fuel_decrease_speed := 10
onready var invulnerability_timer = $InvulnerabilityTimer
onready var animation_player = $AnimationPlayer
onready var player_sprite = $Sprite
onready var guide = $Guide

var max_vertical_speed := 5
var min_vertical_speed := -5
var max_horizontal_speed := 4
var min_horizontal_speed := -4

var has_moved = false

enum states {IDLE, MOVE}
var state = states.IDLE

func _ready():
	animation_player.play("Idle")

func on_killed():
	pass
	
func clampVelocity(vel:Vector2):
	return Vector2(clamp(vel.x, min_horizontal_speed, max_horizontal_speed), clamp(vel.y, min_vertical_speed, max_vertical_speed))
	
func _set_fuel(value):
	var prev_fuel = fuel_amount
	fuel_amount = clamp(value, 0, max_fuel)
	if fuel_amount != prev_fuel:
		emit_signal("fuel_updated", fuel_amount)
		if fuel_amount == 0:
			player_sprite.visible = false
			Lives.player_lives -= 1
			emit_signal("killed", Lives.player_lives)
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
		if !has_moved: 
			has_moved = true
			guide.visible = false
		vertical_speed -= delta * jetpack_acceleration
		reduceFuel(delta*fuel_decrease_speed)
		if state != states.MOVE:
			animation_player.play("Move")
			state = states.MOVE
	else:
		if state != states.IDLE:
			animation_player.play("Idle")
			state = states.IDLE
	if (has_moved):
		vertical_speed += delta * gravity # Gravity
		horizontal_speed += delta * horizontal_acceleration
		velocity += Vector2(horizontal_speed, vertical_speed)
		velocity = clampVelocity(velocity)
		# print(velocity)
		var collision = move_and_collide(velocity)
		if collision != null:
			# Damage taken is based on impact velocity
			var damage_taken = 5 * pow(velocity.length(), 1.25)
			var motion = collision.normal.reflect(collision.remainder.normalized())
			velocity = collision.normal.reflect(velocity.normalized())*bounce_coefficent
			velocity.x = -velocity.x
			damageFuel(damage_taken)
			move_and_collide(motion)
