#flier.gd
extends Node2D

#Variáveis exportáveis
export var speed = 100

#Variáveis
var motion = Vector2()
var dir
var on_way_to_destination = true
var bodies

#Nodes
onready var flier = get_node("KinematicBody2D")
onready var destination = get_node("destination")
onready var player_detector = get_node("KinematicBody2D/player_detector")
onready var raycast = get_node("KinematicBody2D/RayCast2D")

func _physics_process(delta):
	bodies = player_detector.get_overlapping_bodies()
	
	if bodies != null:
		for i in bodies:
			if i.is_in_group("player"):
				motion = speed * (i.get_global_position()-flier.get_global_position()).normalized()
				flier.move_and_slide(motion)
	
	dir = (destination.get_position()-flier.get_position()).normalized()
	
	if flier.get_position() >= destination.get_position():
		on_way_to_destination = false
	elif flier.get_position() <= Vector2(0,0):
		on_way_to_destination = true
	
	if on_way_to_destination == true:
		motion = speed*dir
		flier.move_and_slide(motion)
	elif on_way_to_destination == false:
		motion = speed*-dir
		flier.move_and_slide(motion)