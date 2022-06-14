extends Node2D

var _fuel_supply = 20

func _on_FuelCanister_body_entered(body: KinematicBody2D):
	if (body.name == "Player"):
		body.addFuel(_fuel_supply)
		queue_free()
