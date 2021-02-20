tool
extends Area2D

export(
	String,
	"apple",
	"banana",
	"cherry",
	"kiwi",
	"melon",
	"orange",
	"pinaple",
	"strawbery"
	) var type = 0 setget set_type

func _ready():
	$AnimatedSprite.play(type)
	
func _draw():
	if is_inside_tree() && Engine.editor_hint:
		$AnimatedSprite.play(type)
		$AnimatedSprite.stop()
	
func set_type(value):
	type = value
	update()

func destroy():
	$AnimatedSprite.play("collected")
	yield($AnimatedSprite, "animation_finished")
	queue_free()

func _on_CollectedFruit_area_entered(_area):
	destroy()
