#platform3.gd
extends Node2D

#Variáveis exportáveis
export var speed = 200
export(int,"False","True") var fragile

#Variáveis
var motion = Vector2()
var dir
var on_way_to_destination = true
var bodies

#Nodes
onready var platform = get_node("KinematicBody2D")
onready var destination = get_node("destination")
onready var platform_floor = get_node("KinematicBody2D/Area2D")
onready var destruction_timer = get_node("destruction_timer")

func _ready():
	dir = (destination.get_position()-platform.get_position()).normalized()

func _physics_process(delta):
	if platform.get_position() >= destination.get_position():
		on_way_to_destination = false
	elif platform.get_position() <= Vector2(0,0):
		on_way_to_destination = true
	
	if on_way_to_destination == true:
		motion = speed*dir
		platform.move_and_collide(motion*delta)
	elif on_way_to_destination == false:
		motion = speed*-dir
		platform.move_and_collide(motion*delta)
	
	bodies = platform_floor.get_overlapping_bodies()
	
	if bodies != null:
		for i in bodies:
			i.set_global_position(i.get_global_position()+(motion*delta))

func _on_Area2D_body_entered(body):
	if fragile == 1:
		if body.is_in_group("player") and destruction_timer.get_time_left() <= 0:
			set_modulate(Color(0,0,0.5))
			destruction_timer.start()

func _on_destruction_timer_timeout():
	self.queue_free()
