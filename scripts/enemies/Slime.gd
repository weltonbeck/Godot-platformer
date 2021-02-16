extends KinematicBody2D

export(int) var speed = 20
var movement = Vector2()
var direction = Vector2(-1,0)

func _ready():
	$AnimatedSprite.play("idle")
	
func _physics_process(_delta):
	movement = direction * speed
	movement = move_and_slide(movement, Vector2(0,-1))
	flip()
	
	if is_on_wall() :
		direction = direction * -1
	
func flip() :
	if movement.x < 0 :
		$AnimatedSprite.flip_h = false
	elif movement.x > 0 :
		$AnimatedSprite.flip_h = true

func hitted(_area):
	$AnimatedSprite.play("hit")
	yield($AnimatedSprite,"animation_finished")
	queue_free()
	
func _on_atack_area_entered(area):
	if area.is_in_group("Player"):
		if area.get_parent().has_method("hitted"):
			area.get_parent().hitted(self)
