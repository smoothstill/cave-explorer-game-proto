extends Node2D

onready var _flag = $AnimationPlayer

func _ready():
	_flag.play("Idle")
