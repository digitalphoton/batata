#StartMenu.gd
extends Control

func _on_Start_pressed():
	get_tree().change_scene("res://Interface/Menus/Level Select.tscn")
	self.queue_free()

func _on_Quit_pressed():
	get_tree().quit()
