#controller.gd
extends Node

#Variáveis constantes
const RIGHT = Vector2(1,0)
const LEFT = Vector2(-1,0)
const DOWN = Vector2(0,1)
const UP = Vector2(0,-1)

#Variáveis que podem ser editadas no inspector (canto inferior direito) enquanto este node estiver selecionado
export var acceleration = 80
export var max_speed = 400
export var jump_height = 800
export var gravity = 40
export var max_falling_speed = 800

#Variáveis
var motion = Vector2()
var collision
var knockback_dir
var input_disabled = false

#Node
onready var kb = self.get_parent()
onready var i_d_timer = get_node("input_disabled_timer")

func move(input_right,input_left,input_jump,delta):
	if verify() == false:
		print("Parent is invalid! Parent must be KinematicBody2D")
		return 0
	
	#Sinta o poder da gravidade!
	motion.y += gravity
	motion.y = min(max_falling_speed,motion.y)
	
	if input_disabled == true:
		pass
	else:
		#Movimentos para a direita, esquerda e parado
		if input_right == true and input_left == true:
			motion.x = lerp(motion.x,0,0.4)
		elif input_right == true:
			motion.x += acceleration
			motion.x = min(max_speed, motion.x)
		elif input_left == true:
			motion.x -= acceleration
			motion.x = max(-max_speed, motion.x)
		else:
			motion.x = lerp(motion.x,0,0.4)
		
		#Movimento de pular
		if kb.is_on_floor():
			if input_jump == true:
				motion.y = -jump_height
	
	#Executa o movimento
	motion = kb.move_and_slide(motion,UP)

func knockback(knockback_dir):
	motion = max_speed*-knockback_dir
	motion.y -= jump_height/2
	input_disabled = true
	i_d_timer.start()

func _on_input_disabled_timer_timeout():
	input_disabled = false

func verify():
	if kb.is_class("KinematicBody2D"):
		return true
	else:
		print("Failed to verify")
		return false
