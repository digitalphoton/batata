#pit.gd
extends Area2D

func _on_pit_body_entered(body):
	body.kill()
