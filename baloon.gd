extends Node2D
@export var thrust = 0.
@onready var balloon_states = ["moving","dead"]
@onready var current_state = 0
@onready var speed = Vector2(0.,0.)
@onready var cursor_angle = Vector2(0.,0.)
@export var air_fric = 0.1
#functions
func set_cursor_angle():
	cursor_angle = (globals.mouse_pos - global_position).normalized() * -1.
func set_speed():
	if(Input.is_action_pressed("left_mouse")):
		speed += cursor_angle * thrust * delta_60

#physics

	position += speed
	
#state functions
func moving():
	set_cursor_angle()
	set_speed()


func _on_area_2d_body_entered(body):
	position = Vector2(0.,0.)
