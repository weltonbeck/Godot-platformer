extends Area2D


func _ready():
	pass


func _on_Trampoline_area_entered(area):
	if area.get_parent().has_method("jump"):
		if area.get_parent().is_in_group("Player"):
			area.get_parent().current_jump = 0
		area.get_parent().jump(580)
		$AnimatedSprite.play("active")
