extends Control

onready var _fuel_bar = $CanvasLayer/FuelBar

func _ready():
	var playernode = get_tree().get_root().find_node("Player", true, false)
	print(playernode)
	playernode.connect("fuel_updated", self, "_on_fuel_updated")

func _on_fuel_updated(fuel):
	_fuel_bar.value = fuel
	
func _on_max_fuel_updated(max_fuel):
	_fuel_bar.max_value = max_fuel
