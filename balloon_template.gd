extends "res://character_template.gd"
#onready variables
@onready var cursor_angle = Vector2(0.,0.)
#export vars
@export var thrust = 0.1
#functions
func set_cursor_angle():
	cursor_angle = (globals.mouse_pos - global_position).normalized() * -1.
func set_speed():
	if(Input.is_action_pressed("left_mouse")):
		speed += cursor_angle * thrust * delta_60
#states
func normal_state():
	set_cursor_angle()
	set_speed()
	global_position += speed
func _ready():
	print(min_air_fric)
	states["normal_state"] = "normal_state"
	current_state = "normal_state"
func _process(delta):
	run_state()
	run_physics_states()
