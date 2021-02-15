extends Area2D

func _ready():
	pass

func _on_enemies_area_entered(area):
	if area.get_parent().has_method("hitted"):
		area.get_parent().hitted(self)
