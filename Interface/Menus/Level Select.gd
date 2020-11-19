extends Control

export(String,FILE,"*.tscn") var starting_level_path
export var starting_coordinates = Vector2()

func _on_DEBUG_WORLD_pressed():
	var level_node = get_node("CenterContainer/VBoxContainer/ScrollContainer/VBoxContainer/DEBUG WORLD")
	var level_path = level_node.level_path
	var spawn_coordinates = level_node.spawn_coordinates
	global.change_level(level_path,spawn_coordinates,true)
	self.queue_free()


func _on_LEVEL_11_pressed():
	var level_node = get_node("CenterContainer/VBoxContainer/ScrollContainer/VBoxContainer/LEVEL 1-1")
	var level_path = level_node.level_path
	var spawn_coordinates = level_node.spawn_coordinates
	global.change_level(level_path,spawn_coordinates,true)
	self.queue_free()
