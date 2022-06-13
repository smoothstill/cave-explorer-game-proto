extends KinematicBody2D

signal fuel_updated(fuel_amount)
signal killed(lives)

var _horizontal_acceleration:= 1.0
var _jetpack_acceleration := 15
var _velocity := Vector2(0.0, 0.0)
var _gravity := 5
var _bounce_coefficent = 1.0
export var _max_fuel := 100.0
onready var _fuel_amount = _max_fuel setget _set_fuel, get_fuel
var _fuel_decrease_speed := 10
onready var _invulnerability_timer = $InvulnerabilityTimer
onready var _animation_player = $AnimationPlayer
onready var _player_sprite = $Sprite
onready var _guide = $Guide
onready var _jetpack_sound = $JetpackSound
onready var _collision_sound = $CollisionSound
onready var _explosion_sound = $ExplosionSound
onready var _fuel_pickup_sound = $AddFuelSound

var _max_vertical_speed := 5
var _min_vertical_speed := -5
var _max_horizontal_speed := 4
var _min_horizontal_speed := -4

var _has_moved = false
var _is_dead = false

enum _states {IDLE, MOVE}
var _state = _states.IDLE

func _ready():
	_animation_player.play("Idle")

func on_killed():
	pass
	
func clampVelocity(vel:Vector2):
	return Vector2(clamp(vel.x, _min_horizontal_speed, _max_horizontal_speed), clamp(vel.y, _min_vertical_speed, _max_vertical_speed))
	
func get_fuel():
	return _fuel_amount
	
func _set_fuel(value):
	var prev_fuel = _fuel_amount
	_fuel_amount = clamp(value, 0, _max_fuel)
	if _fuel_amount != prev_fuel:
		emit_signal("fuel_updated", _fuel_amount)
		if _fuel_amount == 0:
			_player_sprite.visible = false
			_is_dead = true
			if _explosion_sound.playing == false:
				_explosion_sound.play()
			Lives.player_lives -= 1
			emit_signal("killed", Lives.player_lives)
			on_killed()
			
func damageFuel(amount):
	if _invulnerability_timer.is_stopped():
		_invulnerability_timer.start()
		_set_fuel(_fuel_amount - amount)
		
func reduceFuel(amount):
	_set_fuel(_fuel_amount - amount)
		
func addFuel(amount):
	if _fuel_pickup_sound.playing == false:
		_fuel_pickup_sound.play()
	_set_fuel(_fuel_amount + amount)
		
func _process(delta):
	var vertical_speed = 0
	var horizontal_speed = 0
	if Input.is_action_pressed("jump"):
		if !_jetpack_sound.playing and !_is_dead:
			_jetpack_sound.play()
		elif _jetpack_sound.playing and _is_dead:
			_jetpack_sound.stop()
		if !_has_moved: 
			_has_moved = true
			_guide.visible = false
		vertical_speed -= delta * _jetpack_acceleration
		reduceFuel(delta*_fuel_decrease_speed)
		if _state != _states.MOVE:
			_animation_player.play("Move")
			_state = _states.MOVE
	else:
		if _state != _states.IDLE:
			_animation_player.play("Idle")
			_state = _states.IDLE
			_jetpack_sound.stop()
	if (_has_moved and !_is_dead):
		vertical_speed += delta * _gravity
		horizontal_speed += delta * _horizontal_acceleration
		_velocity += Vector2(horizontal_speed, vertical_speed)
		_velocity = clampVelocity(_velocity)
		# print(velocity)
		var collision = move_and_collide(_velocity)
		if collision != null:
			# Damage taken is based on impact velocity
			var damage_taken = 5 * pow(_velocity.length(), 1.25)
			var motion = collision.normal.reflect(collision.remainder.normalized())
			_velocity = collision.normal.reflect(_velocity.normalized())*_bounce_coefficent
			_velocity.x = -_velocity.x
			damageFuel(damage_taken)
			move_and_collide(motion)
			if _collision_sound.playing == false:
				_collision_sound.play()
