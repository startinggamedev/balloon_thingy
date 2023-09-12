extends "res://character_template.gd"
#delta debuging
@onready var current_thrust  = Vector2.ZERO
@onready var mytimer = 0.
#onready variables
@onready var cursor_angle = Vector2(0.,0.)
#export vars
@export var thrust = 0.1
@export var thrust_max : float
#functions
func set_cursor_angle():
	cursor_angle = globals.get_cursor_angle_vector(global_position,1.)
func set_speed():
	if(Input.is_action_pressed("left_mouse")):
		current_thrust += thrust  * cursor_angle * delta_60
	else:
		current_thrust = manage_air_friction(current_thrust)
	current_thrust = globals.clamp_vector(current_thrust,0.,thrust_max)
	print(current_thrust.length())
	#add_extra_speed(current_thrust,"linear",thrust_max) 
#debugging
func debug_delta():
	mytimer += delta_60
	if global_position.y >= 2000.:
		print(mytimer)
		global_position.y = 0.
#states
func normal_state():
	set_cursor_angle()
	#set_speed()
	set_linear_speed("thrust",thrust,cursor_angle,0.,thrust_max,Input.is_action_pressed("left_mouse"))
func _ready():
	default_ready()
	states["normal_state"] = "normal_state"
	current_state = "normal_state"
	add_speed_dict_entry(["thrust"])
func _process(delta):
	default_process()
func _physics_process(delta):
	default_physics_process()
