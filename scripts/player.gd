extends KinematicBody2D

signal fuel_updated(fuel_amount)
signal killed(lives)

var _horizontal_acceleration:= 1.0
var _jetpack_acceleration := 15
var _horizontal_resistance := 2
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
onready var _speed_debuff_sound = $SpeedDebuffSound
onready var _speed_buff_sound = $SpeedBuffSound

var _max_vertical_speed := 5
var _min_vertical_speed := -5
var _max_horizontal_speed := 6
var _min_horizontal_speed := -6

var _has_moved = false
var _is_dead = false

enum _states {IDLE, MOVE}
var _state = _states.IDLE

func _ready():
	_animation_player.play("Idle")

func _on_killed():
	pass
	
func _clampVelocity(vel:Vector2):
	return Vector2(clamp(vel.x, _min_horizontal_speed, 9999), clamp(vel.y, _min_vertical_speed, _max_vertical_speed))
	
func get_fuel():
	return _fuel_amount
	
func increase_horizontal_speed(value):
	var speed_x = max(_velocity.x + value, 0)
	_velocity = _clampVelocity(Vector2(speed_x, _velocity.y))
	
func decrease_velocity(amount):
	var magnitude = _velocity.length()
	var unit_vec = Vector2(_velocity).normalized()
	_velocity = unit_vec * max(magnitude - amount, 0)
	
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
			_on_killed()
			
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
	
func play_debuff_sound():
	_speed_debuff_sound.play()
		
func play_buff_sound():
	_speed_buff_sound.play()
		
func _physics_process(delta):
	# Only process if level has not stopped
	if LevelManager.get_level_state() == LevelManager.states.STOPPED:
		if _jetpack_sound.playing:
			_jetpack_sound.stop()
		return
	var vertical_speed = 0
	var horizontal_speed = 0
	if Input.is_action_pressed("jump"):
		# If moves for the first time
		if !_has_moved: 
			_has_moved = true
			_guide.visible = false
		vertical_speed -= delta * _jetpack_acceleration
		reduceFuel(delta * _fuel_decrease_speed)
		if _state != _states.MOVE:
			_animation_player.play("Move")
			if !_jetpack_sound.playing:
				_jetpack_sound.play()
			_state = _states.MOVE
	else:
		if _state != _states.IDLE:
			_animation_player.play("Idle")
			_jetpack_sound.stop()
			_state = _states.IDLE
	if (_has_moved):
		vertical_speed += delta * _gravity
		horizontal_speed += delta * _horizontal_acceleration
		if _velocity.x > _max_horizontal_speed:
			horizontal_speed -= delta * _horizontal_resistance
		_velocity += Vector2(horizontal_speed, vertical_speed)
		_velocity = _clampVelocity(_velocity)
		var collision = move_and_collide(_velocity)
		if collision != null:
			# Damage taken is based on impact velocity
			var damage_taken = 2.5 * pow(_velocity.length(), 1.25)
			var motion = collision.normal.reflect(collision.remainder.normalized())
			_velocity = collision.normal.reflect(_velocity.normalized())*_bounce_coefficent
			_velocity.x = -_velocity.x
			damageFuel(damage_taken)
			move_and_collide(motion)
			if _collision_sound.playing == false:
				_collision_sound.play()
