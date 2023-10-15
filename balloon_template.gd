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
#physics logic states
func balloon_physics():
	set_linear_speed("thrust",thrust,cursor_angle,0.,thrust_max,Input.is_action_pressed("left_mouse"))
#process states
func normal_state():
	set_cursor_angle()
func _ready():
	current_physics_logic_state = "balloon_physics"
	default_ready()
	states["normal_state"] = "normal_state"
	current_state = "normal_state"
	add_speed_dict_entry(["thrust"])
func _process(delta):
	default_process()
func _physics_process(delta):
	default_physics_process()
