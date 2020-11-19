#enemy_j.gd
extends KinematicBody2D

#Variáveis
var jump = true

#Nodes
onready var stats = get_node("enemy_stats")
onready var controller = get_node("controller")
onready var jump_cooldown = get_node("jump_cooldown")

func _physics_process(delta):
	controller.move(false,false,jump,delta)
	
	if jump == true:
		jump = false
		jump_cooldown.start()
	
	if stats.health <= 0:
		self.kill()

func _on_jump_cooldown_timeout():
	jump = true

func take_damage(damage,damage_dir):
	stats.health -= damage
	controller.knockback(damage_dir)

func kill():
	self.queue_free()
