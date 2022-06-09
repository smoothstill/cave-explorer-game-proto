extends Node2D

var fuel_supply = 20

func _on_FuelCanister_body_entered(body: KinematicBody2D):
	if (body.name == "Player"):
		body.addFuel(body.fuel_amount + fuel_supply)
		queue_free()
