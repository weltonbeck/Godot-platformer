extends Area2D

func _ready():
	pass
	
func hitted(_area):
	pass

func _on_enemies_area_entered(area):
	if area.is_in_group("Player"):
		if area.get_parent().has_method("hitted"):
			area.get_parent().hitted(self)
