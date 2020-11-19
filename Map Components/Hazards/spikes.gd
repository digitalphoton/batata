#spikes.gd
extends Area2D

#Variáveis exportáveis
export var spike_damage = 2

#Variáveis
var bodies

func _process(delta):
	bodies = get_overlapping_bodies()
	
	if bodies != null:
		for i in bodies:
			if i.is_in_group("player"):
				i.take_damage(spike_damage,(self.get_global_position()-i.get_global_position()).normalized())
