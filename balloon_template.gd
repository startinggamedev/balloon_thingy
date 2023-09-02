extends "res://character_template.gd"
#delta debuging
@onready var mytimer = 0.
#onready variables
@onready var cursor_angle = Vector2(0.,0.)
#export vars
@export var thrust = 0.1
#functions
func set_cursor_angle():
	cursor_angle = globals.get_cursor_angle_vector(global_position,-1.)
func set_speed():
	if(Input.is_action_pressed("left_mouse")):
		speed +=  thrust * delta_60 * cursor_angle 
#debugging
func debug_delta():
	mytimer += delta_60
	if global_position.y >= 2000.:
		print(mytimer)
		global_position.y = 0.
#states
func normal_state():
	set_cursor_angle()
	set_speed()
func _ready():
	default_ready()
	states["normal_state"] = "normal_state"
	current_state = "normal_state"
func _process(delta):
	default_process()
