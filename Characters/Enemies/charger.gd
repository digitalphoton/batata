#enemy_c.gd
extends KinematicBody2D

#Variáveis que podem ser editadas no inspector (canto inferior direito) enquanto este node estiver selecionado
export var right = true
export var default_speed = 100

#Variáveis
var charge = false

#Nodes
onready var stats = get_node("enemy_stats")
onready var controller = get_node("controller")
onready var edge_detector = get_node("edge_detector")
onready var player_detector = get_node("player_detector")
onready var timer = get_node("player_detection_timer")

func _physics_process(delta):
	if charge == false:
	#Verifica se este personagem está vendo o player e não uma parede e se o player existe
		if player_detector.is_colliding() and player_detector.get_collider() != null and player_detector.get_collider().is_in_group("player"):
			timer.start()
			controller.max_speed = 0
			charge = true
		
	#Ronda
		else:
			controller.max_speed = default_speed
			if self.is_on_wall() or !edge_detector.is_colliding():
				right = !right
				edge_detector.set_position(-edge_detector.get_position())
				player_detector.set_cast_to(-player_detector.get_cast_to())
	
	elif self.is_on_wall():
		stats.damage = stats.damage/2
		charge = false
	
	controller.move(right,!right,false,delta)
	
	if stats.health <= 0:
		self.kill()

func _on_player_detection_timer_timeout():
	stats.damage = stats.damage*2
	controller.max_speed = default_speed*5

func take_damage(damage,damage_dir):
	stats.health -= damage
	controller.knockback(damage_dir)

#Função para deletar esta scene
func kill():
	self.queue_free()
