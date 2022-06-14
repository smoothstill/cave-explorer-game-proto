extends Area2D

onready var _sprite = $Sprite
var _max_rotation = 0.349
var _dir = 1
var _rotate_speed = 1

func _on_SpeedBuff_body_entered(body):
	if (body.name == "Player"):
		# Increase horizontal speed
		body.increase_horizontal_speed(3.0)
		body.play_buff_sound()
		queue_free()
		
func _process(delta):
	if abs(_sprite.rotation + _rotate_speed * delta) > _max_rotation:
		_dir *= -1
	_sprite.rotate(_dir * _rotate_speed * delta)

