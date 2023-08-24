extends Node2D
@export var thrust = 0.
@onready var balloon_states = ["moving","dead"]
@onready var current_state = 0
@onready var speed = Vector2(0.,0.)
@onready var cursor_angle = Vector2(0.,0.)
@onready var is_left_press = false
@export var air_fric = 0.1
#functions
#input
func input_check():
	is_left_press = Input.is_action_pressed("left_mouse")
#logic
func set_cursor_angle():
	cursor_angle = (globals.mouse_pos - global_position).normalized() * -1.
func set_speed():
	if(is_left_press):
		speed += cursor_angle * thrust
	else:
		speed = lerp(speed,Vector2(0.,0.),air_fric)
#physics
func physics():
	position += speed
	
#state functions
func moving():
	set_cursor_angle()
	set_speed()
#processes
func _process(delta):
	input_check()
	call(balloon_states[current_state])
	physics()

func _on_area_2d_body_entered(body):
	position = Vector2(0.,0.)
