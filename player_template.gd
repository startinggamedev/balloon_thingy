extends "res://character_template.gd"
#delta debuging

@onready var mytimer = 0.
#onready variables
#export vars
@export var thrust = 0.1
@export var thrust_max : float
#functions
#physics logic states
func balloon_physics():
	set_linear_speed("thrust",spd_res.acceleration,globals.get_cursor_angle_vector(global_position),0.,thrust_max,Input.is_action_pressed("move"))
#process states
func _ready():
	current_physics_logic_state = "balloon_physics"
	default_ready()
	add_speed_dict_entry(["thrust"])
func _process(delta):
	default_process()
func _physics_process(delta):
	default_physics_process()
