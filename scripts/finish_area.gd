extends Node2D

signal level_clear()

func _on_FinishArea_body_entered(body):
	if (body.name == "Player"):
		emit_signal("level_clear")
		# Remove finish line from game
		queue_free()
