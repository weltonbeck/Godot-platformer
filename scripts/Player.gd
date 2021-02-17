extends KinematicBody2D

const INTANGIBLE_TIME = 2
var intangible = false

const MAX_SPEED = 100
const GRAVITY = 20
const MAX_JUMP_FORCE = 380
const MIN_JUMP_FORCE = 100
var total_extra_jumps = 1
var current_jump = 0

var movement = Vector2(0, 0)
var input_x = 0

enum {
	APPEARING, DESAPPEARING,
	IDLE, WALK, JUMP, FALL, WALL_JUMP, HIT
}

var status = IDLE

func _ready():
	status = APPEARING
	yield($AnimatedSprite, "animation_finished")
	status = IDLE

func animation():
	
	if status == IDLE:
		$AnimatedSprite.play("idle")
	elif status == WALK:
		$AnimatedSprite.play("walk")
	elif status == JUMP:
		if (current_jump > 1):
			$AnimatedSprite.play("double_jump")
		else:
			$AnimatedSprite.play("jump")
	elif status == FALL:
		$AnimatedSprite.play("fall")
	elif status == HIT:
		$AnimatedSprite.play("hit")
		yield($AnimatedSprite, "animation_finished")
		status = IDLE
	elif status == APPEARING:
		$AnimatedSprite.play("appearing")
	elif status == DESAPPEARING:
		$AnimatedSprite.play("desappearing")
		
	if intangible == true:
		$Intangible/Animation.play("intangible")
	else :
		$Intangible/Animation.play("idle")
		
	if !(status == APPEARING ||
		status == DESAPPEARING ||
		status == HIT):
		if is_on_floor():
			if input_x == 0:
				status = IDLE
			else: 
				status = WALK
		elif movement.y > 0:
			status = FALL

func _physics_process(_delta):
	movement.y += GRAVITY
	walk()
	flip()
	pass_through()
	
	if Input.is_action_just_pressed("ui_jump") :
		# pulo extra
		if (status == JUMP || status == FALL) && current_jump <= total_extra_jumps :
			jump(MAX_JUMP_FORCE)
		# pulo normal
		if status == IDLE || status == WALK :
			jump(MAX_JUMP_FORCE)
		
	if (status == JUMP && 
		movement.y < -MIN_JUMP_FORCE &&
		Input.is_action_just_released("ui_jump")):
		movement.y = -MIN_JUMP_FORCE
		
	movement = move_and_slide(movement, Vector2(0,-1))
	
	if is_on_floor() :
		movement.y = 0
		current_jump = 0
	
	animation()

func flip() :
	if input_x > 0 :
		$AnimatedSprite.flip_h = false
	elif input_x < 0 :
		$AnimatedSprite.flip_h = true
		
func walk():
	input_x = 0
	# caso possa se mover
	if !(status == APPEARING ||
		status == DESAPPEARING ||
		status == HIT):	
		input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if input_x != 0:
		movement.x = MAX_SPEED * input_x
	elif input_x == 0:
		movement.x = lerp(movement.x,0, 0.2)

func jump(force):
	current_jump += 1
	movement.y = -force
	if status != HIT:
		status = JUMP
		
func pass_through():
	if Input.is_action_just_pressed("ui_down") :
		var verify = false
		for i_collision in range(0, get_slide_count() - 1):
			var collision = get_slide_collision(i_collision)
			if collision.collider.is_in_group("PassThrough"):
				verify = true
		if verify == true :
			set_collision_mask_bit(1, false)
			yield(get_tree().create_timer(0.03), "timeout")
			set_collision_mask_bit(1, true)

func hitted(_area):
	if intangible == false:
		intangible = true
		status = HIT
		yield(get_tree().create_timer(INTANGIBLE_TIME),"timeout")
		intangible = false

func _on_make_a_jumphit_area_entered(area):
	if intangible == false:
		if area.is_in_group("Enemies"):
			current_jump = 0
			jump(MAX_JUMP_FORCE)
			if area.get_parent().has_method("hitted"):
				area.get_parent().hitted(self)
