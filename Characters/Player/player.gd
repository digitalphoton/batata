#player.gd
extends KinematicBody2D

#Variáveis exportáveis
#Stats
export var max_health = 100
export var bullet_damage = 25

export(String,FILE,"*.tscn") var spawn_scene_path
export var spawn_coordinates = Vector2()

#Variáveis
#Stats
var health
var collectables_counter

var player_input = {}
var player_dir
var can_shoot = true
var damage_disabled = false

#Nodes
onready var controller = get_node("controller")
onready var muzzle_pos = get_node("muzzle_pos")
onready var shoot_cooldown_scene = get_node("shoot_cooldown")
onready var damage_disabled_timer = get_node("damage_disabled_timer")

#Scenes
onready var bullet_scene = preload("res://Characters/Weapons/bullet.tscn")

#Signals
signal health_changed
signal player_died
signal collectable_get

func _ready():
	if health == null:
		health = max_health
	emit_signal("health_changed",max_health,health,0)

func _physics_process(delta):
	#Teclas pressionadas para as ações do personagem. Podem ser encontradas em Project>>Project Settings>>Input Map
	player_input.right = Input.is_action_pressed("right")
	player_input.left = Input.is_action_pressed("left")
	player_input.jump = Input.is_action_pressed("jump")
	player_input.shoot = Input.is_action_pressed("shoot")
	player_dir = (get_global_mouse_position() - get_global_position()).normalized()
	
		#Controla a ação de atirar
	if player_input.shoot and can_shoot == true:
		var bullet = bullet_scene.instance()
		bullet.setup("friend",muzzle_pos.get_global_position(),player_dir,bullet_damage)
		get_parent().add_child(bullet)
		can_shoot = false
		shoot_cooldown_scene.start()
	
	#Controla o movimento do personagem
	controller.move(player_input.right,player_input.left,player_input.jump,delta)
	
	if health <= 0:
		self.kill()
	
	if Input.is_action_pressed("ui_cancel"):
		#Volta pro menu inicial
		get_tree().change_scene("res://Interface/Menus/startmenu.tscn")

func _on_shoot_cooldown_timeout():
	can_shoot = true

#Se o player encosta perto de um inimigo, o player morre
func _on_hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		self.take_damage(body.stats.damage,(body.get_global_position() - self.get_global_position()).normalized())
	elif body.is_in_group("collectables"):
		print("Collectable Get!")
		emit_signal("collectable_get")
		body.queue_free()

func take_damage(damage,damage_dir):
	if damage_disabled == false:
		health -= damage
		emit_signal("health_changed",max_health,health,damage)
		controller.knockback(damage_dir)
		damage_disabled = true
		damage_disabled_timer.start()

func _on_damage_disabled_timer_timeout():
	damage_disabled = false

func kill():
	health = max_health
	global.change_level(spawn_scene_path,spawn_coordinates)
