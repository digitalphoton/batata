#collectable.gd
extends KinematicBody2D

#Variáveis exportáveis
export var gravity = 40
export var max_falling_speed = 800

#Variáveis
var collision
var motion = Vector2()

func _physics_process(delta):
	motion.y += gravity
	motion.y = min(max_falling_speed,motion.y)
	
	move_and_collide(motion*delta)
