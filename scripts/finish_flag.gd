extends Node2D

onready var flag = $AnimationPlayer

func _ready():
	flag.play("Idle")
