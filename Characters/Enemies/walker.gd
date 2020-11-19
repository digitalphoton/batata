#enemy_w.gd
extends KinematicBody2D

#Variáveis exportáveis
export var right = true
export var drop_chance = 50

#Nodes
onready var stats = get_node("enemy_stats")
onready var controller = get_node("controller")
onready var edge_detector = get_node("edge_detector")

#Scenes
onready var collectable_scene = preload("res://Characters/Collectables/collectable.tscn")

func _physics_process(delta):
	#Faz este NPC virar quando não estiver em movimento, ou seja, se bater em uma parede
	if self.is_on_wall() or !edge_detector.is_colliding():
		right = !right
		edge_detector.set_position(-edge_detector.get_position())
	
	#Controla o movimento do NPC
	controller.move(right,!right,false,delta)
	
	if stats.health <= 0:
		self.kill()

func take_damage(damage,damage_dir):
	stats.health -= damage
	controller.knockback(damage_dir)

#Função para deletar esta scene
func kill():
	if rand_range(0,100) < drop_chance:
		var collectable = collectable_scene.instance()
		collectable.set_global_position(get_global_position())
		get_parent().add_child(collectable)
	self.queue_free()
