tool
extends Path2D

const COLLECTED = preload("res://scennes/itens/CollectedFruit.tscn")

export var distance = 30 setget set_distance
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
	populate()
	
func set_distance(value):
	distance = value
	update()
	
func set_type(value):
	type = value
	update()
	
func _draw():
	if is_inside_tree() && Engine.editor_hint:
		populate()
	
func populate():
	# remove todos
	for collected in get_children():
		collected.queue_free()
		
	var curve = get_curve()
	var length = curve.get_baked_length()
	var i = 0
	while i < length:
		var position = curve.interpolate_baked(i)
		i += distance
		var new_collected = COLLECTED.instance()
		new_collected.position = position
		new_collected.type = type
		add_child(new_collected)
