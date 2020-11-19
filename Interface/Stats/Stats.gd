#Stats.gd
extends Control

#Variáveis
var health_change = false
var counter = 0

#Nodes
onready var HPBar_white = get_node("HPBar/HPBar_white")
onready var HPBar_red = get_node("HPBar/HPBar_red")
onready var CollectableCounter = get_node("MarginContainer/CollectablesCounter/HBoxContainer/NUMBER")

func _process(delta):
	if health_change == true:
		HPBar_white.set_value(HPBar_white.get_value()-1)
	elif HPBar_white.get_value() == HPBar_red.get_value():
		health_change = false

func _on_player_health_changed(max_health,health,damage):
	HPBar_red.set_value((health*100)/max_health)
	HPBar_white.set_value(((health+damage)*100)/max_health)
	health_change = true

func _on_player_collectable_get():
	counter += 1
	CollectableCounter.text = str(counter)
