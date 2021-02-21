extends StaticBody2D

export (PackedScene) var resource = null
export(bool) var destroy_after_invoque = true

var active = false

func _ready():
	pass

func hit():
	active = true
	$AnimatedSprite.play("hit")
	if (resource) :
		var new_collected = resource.instance()
		new_collected.global_position = $Position2D.global_position
		get_tree().get_root().add_child(new_collected)
		if (destroy_after_invoque && new_collected.has_method("destroy")):
			yield(get_tree().create_timer(.5), "timeout")
			new_collected.destroy()

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") && active == false:
		hit()
