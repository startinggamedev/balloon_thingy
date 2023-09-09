extends "res://templates/motion force field/attraction_field.gd"
#export vars
@export var opening_degree = 45.
@export var cone_length = 100.
#onready vars
@onready var accuracy = 0.
@onready var i = 0.
@onready var angle_mutiplier = 0.
@onready var my_vector_array = []
func set_cone_field():
	my_vector_array.resize(int(accuracy + 2))
	for i in accuracy + 1:
		angle_mutiplier = i/accuracy
		my_vector_array[i] = Vector2(cos(deg_to_rad(opening_degree * angle_mutiplier)),sin(deg_to_rad(opening_degree * angle_mutiplier))) * cone_length
	my_vector_array[accuracy + 1] = Vector2(0.,0.)
	field_area.shape.points = my_vector_array
func _process(delta):
	accuracy =roundf(opening_degree* cone_length/2000)
	print(accuracy)
	set_cone_field()
