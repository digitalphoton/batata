#turret.gd
extends KinematicBody2D

#Variáveis
var shoot = false

#Nodes
onready var player = get_parent().get_node("player")
onready var stats = get_node("enemy_stats")
onready var muzzle_pos = get_node("muzzle_pos")
onready var shoot_cooldown = get_node("shoot_cooldown")

#Scenes
onready var bullet_scene = preload("res://Characters/Weapons/bullet.tscn")

func _physics_process(delta):
	if player == null:
		player = get_parent().get_node("player")
	
	if shoot == true and player != null:
		var bullet = bullet_scene.instance()
		bullet.setup("enemy",muzzle_pos.get_global_position(),(player.get_global_position()-self.get_global_position()).normalized(),stats.bullet_damage)
		get_parent().add_child(bullet)
		shoot = false
		shoot_cooldown.start()
	
	if stats.health <= 0:
		self.kill()

func _on_shoot_cooldown_timeout():
	shoot = true

func take_damage(damage):
	stats.health -= damage

func _on_VisibilityNotifier2D_screen_entered():
	shoot = true

func _on_VisibilityNotifier2D_screen_exited():
	shoot = false

func kill():
	self.queue_free()
