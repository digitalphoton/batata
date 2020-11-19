extends KinematicBody2D

export var GRAVITY = 5000.0
export var bounciness = 0.7
export var vertical_impulse = 800
export var horizontal_impulse = 800
var velocity = Vector2()

var flag = 0
var squashed = false

func _ready():
	get_child(2).set_one_shot(true)

func _process(delta):
	if Input.is_action_just_pressed("teleport"):
		self.set_position(get_global_mouse_position())

func _physics_process(delta):
	print(velocity.y)
	velocity.y += delta * GRAVITY
		
	if self.is_on_floor() or self.is_on_wall():
		if Input.is_action_pressed("left"):
			get_child(1).set_flip_v(false)
			get_child(1).set_flip_h(true)
			get_child(1).play("jump")
			get_child(2).start()
			flag = 1
		if Input.is_action_pressed("right"):
			get_child(1).set_flip_v(false)
			get_child(1).set_flip_h(false)
			get_child(1).play("jump")
			get_child(2).start()
			flag = 2
		if Input.is_action_pressed("up"):
			velocity.x = 0
			velocity.y = -vertical_impulse
			
	var motion = velocity
	move_and_slide(motion, Vector2(0, -1))
	
	if self.is_on_floor():
		velocity.y = -velocity.y*bounciness
		if abs(velocity.y) <= 100:
			velocity.y = 0
	if self.is_on_floor():
		velocity.x *= bounciness
		if abs(velocity.x) <= 100:
			velocity.x = 0
	if self.test_move(self.transform, Vector2(-1, 0)) or self.test_move(self.transform, Vector2(1, 0)):
		velocity.x = -velocity.x*bounciness
		if abs(velocity.x) <= 100:
			velocity.x = 0
#	if self.is_on_floor():
#		velocity.y = 0
#	if self.is_on_wall() or self.is_on_floor():
#		velocity.x = 0 


func _on_AnimatedSprite_animation_finished():
	
	if self.is_on_floor() and !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		get_child(1).set_flip_v(false)
		if squashed == false:
			get_child(1).play("squash")
			squashed = true
		else:
			get_child(1).play("idle")
	elif velocity.y > 0 and !self.is_on_floor():
		get_child(1).set_flip_v(false)
		get_child(1).play("falling")
		squashed = false
	elif velocity.y < 0 and !self.is_on_floor() and velocity.x == 0:
		get_child(1).set_flip_v(true)
		get_child(1).play("falling")
	else:
		if velocity.x > 0:
			get_child(1).set_flip_v(false)
			get_child(1).set_flip_h(false)
			get_child(1).play("flying")
		elif velocity.x < 0:
			get_child(1).set_flip_v(false)
			get_child(1).set_flip_h(true)
			get_child(1).play("flying")



func _on_Timer_timeout():
	if flag == 1:
		velocity.x = -horizontal_impulse
		velocity.y = -vertical_impulse
	if flag == 2:
		velocity.x = horizontal_impulse
		velocity.y = -vertical_impulse
