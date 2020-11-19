#portal.gd
extends Area2D

#Variáveis exportáveis
export(String,FILE,"*.tscn") var level_to_path
export var coordinates_to = Vector2()

func _on_portal_body_entered(body):
	if body.is_in_group("player"):
		global.change_level(level_to_path,coordinates_to)