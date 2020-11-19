#bullet.gd
extends KinematicBody2D

#Variáveis que podem ser editadas no inspector (canto inferior direito) enquanto este node estiver selecionado
export var speed = 600

#Variáveis
var motion
var bullet_dir
var bullet_type
var bullet_damage

#Nodes
onready var hitbox = get_node("hitbox")

#Função que pode ser usada para setar a posição e a direção dessa scene antes de ser instanciada (colocada no mundo)
func setup(type,pos,dir,damage):
	bullet_type = type
	self.set_global_position(pos)
	bullet_dir = dir
	bullet_damage = damage

func _physics_process(delta):
	#Setando a variável motion como um Vector2, não sei porque estava bugando setando na seção das variáveis
	motion = Vector2()
	
	#Controla o movimento da bala e se ela vai aparecer indo para a direita ou para a esquerda
	motion = speed*bullet_dir*delta
	motion = move_and_collide(motion)

#Detecta se acertar a parede ou um inimigo
func _on_hitbox_body_entered(body):
	if body.is_in_group("walls_floors_ceilings") or body.is_in_group("platforms"):
		self.kill()
	elif bullet_type == "friend":
		if body.is_in_group("enemies"):
			body.take_damage(bullet_damage,(self.get_global_position() - body.get_global_position()).normalized())
			self.kill()
		if body.is_in_group("turrets"):
			body.take_damage(bullet_damage)
			self.kill()
	elif bullet_type == "enemy" and body.is_in_group("player"):
		body.take_damage(bullet_damage,(self.get_global_position() - body.get_global_position()).normalized())
		self.kill()

#Detecta se acerta outra bala
func _on_hitbox_area_entered(area):
	if area.owner.is_in_group("bullets"):
		area.owner.kill()
		self.kill()

#Se auto-deleta quando estiver fora da tela do jogo
func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()

func kill():
	self.queue_free()
