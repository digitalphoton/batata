extends KinematicBody2D

export var GRAVITY = 500.0
export var bounciness = 0.7
export var vertical_impulse = 1000
export var horizontal_impulse = 1000
var velocity = Vector2()

var flag = 0
var squashed = false

func _ready():
	get_child(2).set_one_shot(true)


func _process(delta):
	if Input.is_action_just_pressed("teleport"):
		self.set_position(get_global_mouse_position())
	
	if self.is_on_floor() or self.is_on_wall() or self.is_on_ceiling():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up"):
			show_windup()
		elif squashed == false and (self.is_on_wall() or self.is_on_floor() or self.is_on_ceiling()):
			show_squashed()
		elif self.is_on_floor():
			show_idle()
	else:
		vertical_impulse = 0
		horizontal_impulse = 0
		squashed = false
		show_airborne()

func _physics_process(delta):
	velocity.y += delta * GRAVITY
		
	if self.is_on_floor() or self.is_on_wall():
		if Input.is_action_pressed("left"):
			get_child(2).start()
			flag = 1
		if Input.is_action_pressed("right"):
			get_child(2).start()
			flag = 2
		if Input.is_action_pressed("up"):
			get_child(2).start()
			flag = 3
#			velocity.x = 0
#			velocity.y = -vertical_impulse
			
	var motion = velocity
	move_and_slide(motion, Vector2(0, -1))
	
	if self.is_on_floor():
		velocity.y = -velocity.y*bounciness
		if abs(velocity.y) <= 50:
			velocity.y = 0
	if self.is_on_ceiling():
		velocity.y = -velocity.y*bounciness
		if abs(velocity.y) <= 50:
			velocity.y = 0
	if self.is_on_floor():
		velocity.x *= bounciness 
		if abs(velocity.x) <= 50:
			velocity.x = 0
	if self.test_move(self.transform, Vector2(-1, 0)) or self.test_move(self.transform, Vector2(1, 0)):
		velocity.x = -velocity.x*bounciness
		if abs(velocity.x) <= 10:
			velocity.x = 0
#	if self.is_on_floor():
#		velocity.y = 0
#	if self.is_on_wall() or self.is_on_floor():
#		velocity.x = 0 


func _on_Timer_timeout():
	if flag == 1:
		velocity.x = horizontal_impulse
		velocity.y = -vertical_impulse
	if flag == 2:
		velocity.x = horizontal_impulse
		velocity.y = -vertical_impulse
	if flag == 3:
		velocity.x = horizontal_impulse
		velocity.y = -vertical_impulse

func show_squashed():
	flag = 0
	get_child(2).start()
	print("squashed")
	get_child(get_node("Idle").get_index()).set_visible(false)
	get_child(get_node("Airborne").get_index()).set_visible(false)
	get_child(get_node("Wind up").get_index()).set_visible(false)
	if self.is_on_floor():
		get_child(get_node("Squash").get_index()).set_rotation(0)
		get_child(get_node("Squash").get_index()).set_flip_v(false)
		get_child(get_node("Squash").get_index()).set_visible(true)
		squashed = true
	elif self.test_move(self.transform, Vector2(-1, 0)) and self.is_on_wall():
		get_child(get_node("Squash").get_index()).set_rotation(deg2rad(90))
		get_child(get_node("Squash").get_index()).set_visible(true)
		squashed = true
	elif self.test_move(self.transform, Vector2(1, 0)) and self.is_on_wall():
		get_child(get_node("Squash").get_index()).set_rotation(deg2rad(-90))
		get_child(get_node("Squash").get_index()).set_visible(true)
		squashed = true
	elif self.is_on_ceiling():
		get_child(get_node("Squash").get_index()).set_rotation(0)
		get_child(get_node("Squash").get_index()).set_flip_v(true)
		get_child(get_node("Squash").get_index()).set_visible(true)
		squashed = true

func show_idle():
	if get_child(2).is_stopped():
		get_child(get_node("Idle").get_index()).set_visible(true)
		get_child(get_node("Airborne").get_index()).set_visible(false)
		get_child(get_node("Wind up").get_index()).set_visible(false)
		get_child(get_node("Squash").get_index()).set_visible(false)
	
func show_airborne():
	if velocity.x == 0:
		velocity.x = 1
	if get_child(2).is_stopped():
		get_child(get_node("Idle").get_index()).set_visible(false)
		get_child(get_node("Airborne").get_index()).set_visible(true)
		get_child(get_node("Wind up").get_index()).set_visible(false)
		get_child(get_node("Squash").get_index()).set_visible(false)
		get_child(get_node("Airborne").get_index()).set_rotation(PI/2-atan2(-velocity.y, velocity.x))
	if velocity.x == 1:
		velocity.x = 0
	
func show_windup():
	get_child(2).start()
	get_child(get_node("Idle").get_index()).set_visible(false)
	get_child(get_node("Airborne").get_index()).set_visible(false)
	if self.is_on_wall():
		get_child(get_node("Squash").get_index()).set_visible(false)
		if self.test_move(self.transform, Vector2(-1, 0)) and self.is_on_wall():
			get_child(get_node("Wind up").get_index()).set_rotation(deg2rad(90))
			get_child(get_node("Wind up").get_index()).set_visible(true)
		elif self.test_move(self.transform, Vector2(1, 0)) and self.is_on_wall():
			get_child(get_node("Wind up").get_index()).set_rotation(deg2rad(-90))
			get_child(get_node("Wind up").get_index()).set_visible(true)
		
	else: 
		get_child(get_node("Wind up").get_index()).set_rotation_degrees(0)
		if Input.is_action_pressed("up"):
			vertical_impulse += 5
			get_child(get_node("Wind up").get_index()).set_visible(false)
			get_child(get_node("Squash").get_index()).set_visible(true)
		if Input.is_action_pressed("left"):
			horizontal_impulse -= 5
			get_child(get_node("Wind up").get_index()).set_flip_h(true)
			get_child(get_node("Wind up").get_index()).set_visible(true)
			get_child(get_node("Squash").get_index()).set_visible(false)
		if Input.is_action_pressed("right"):
			horizontal_impulse += 5
			get_child(get_node("Wind up").get_index()).set_flip_h(false)
			get_child(get_node("Wind up").get_index()).set_visible(true)
			get_child(get_node("Squash").get_index()).set_visible(false)
