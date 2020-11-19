#global.gd
extends Node

#Variáveis
var player_health
var player_existed
var spawn_scene
var spawn_coordinates

#Nodes
onready var root = get_tree().get_root()
onready var current_level

#Scenes
onready var player_scene = preload("res://Characters/Player/player.tscn")

func change_level(level_path,player_coordinates,set_spawn = false):
	call_deferred("_deferred_change_level",level_path,player_coordinates)

func _deferred_change_level(path,coordinates,set_spawn = false):
	#Pegar o nível atual
	current_level = root.get_child(root.get_child_count()-1)
	
	#Checar se o jogador existe
	if current_level != null and current_level.get_node("player") != null:
		player_existed = true
	else:
		player_existed = false
	
	#Salvar informação do jogador se tiver
	if player_existed:
		player_health = current_level.get_node("player").health
		spawn_scene = current_level.get_node("player").spawn_scene_path
		spawn_coordinates = current_level.get_node("player").spawn_coordinates
	
	#Mudar a cena do estágio
	current_level.free()
	var l = load(path)
	current_level = l.instance()
	get_tree().get_root().add_child(current_level)
	get_tree().set_current_scene(current_level)
	
	#Criar novo jogador
	var new_player = player_scene.instance()
	var cell_size = current_level.get_node("TileMap").cell_size
	new_player.set_global_position((coordinates*cell_size)+Vector2(32,32))
	
	#Seta o spawn point do novo jogador
	if set_spawn or !player_existed:
		new_player.spawn_scene_path = path
		new_player.spawn_coordinates = coordinates
	else:
		new_player.spawn_scene_path = spawn_scene
		new_player.spawn_coordinates = spawn_coordinates
	
	#Passar a informação do jogador velho pro novo se tiver
	if player_existed:
		new_player.health = player_health
	
	#Colocar o novo jogador no jogo
	current_level.add_child(new_player)
