extends Area2D

onready var _sprite = $Sprite
var _max_rotation = 0.349
var _dir = 1
var _rotate_speed = 1

func _on_SpeedDebuff_body_entered(body):
	if (body.name == "Player"):
		# Decrease horizontal speed
		body.decrease_velocity(4.0)
		body.play_debuff_sound()
		queue_free()

func _process(delta):
	if abs(_sprite.rotation + _rotate_speed * delta) > _max_rotation:
		_dir *= -1
	_sprite.rotate(_dir * _rotate_speed * delta)
