extends CharacterBody2D
#onready vars
@onready var delta_60 = null
@onready var speed = Vector2(0.,0.)
@onready var prev_global_position
@onready var physics_states = {"normal_physics" : "normal_physics","intangible_physics" : "intangible_physics"}
@onready var current_physics_state = "normal_physics"
@onready var real_air_friction = speed
#export vars
@export var air_fric = 0.
@export var min_air_fric = 0.
@export var max_air_fric = INF
# functions
#physics states
func normal_physics(): #normal
	manage_speed()
	manage_air_friction()
	collision()
	return physics_return()
func intangible_physics(): #intangible
	manage_speed()
	return physics_return()
#physics states functions
func run_physics_states(): # run the physics states
	return call(physics_states[current_physics_state])
func collision(): #collide
	move_and_slide()
func manage_speed(): #move the body
	prev_global_position = global_position
	global_position += speed
func physics_return(): #what the physics states functions will return
	return global_position - prev_global_position
func manage_air_friction():
	if !air_fric: return
	real_air_friction = air_fric * speed.length() * speed.length()
	real_air_friction = clamp(real_air_friction,min_air_fric,max_air_fric)
	if !is_on_floor():
		if speed.length() < abs(real_air_friction):
			speed = Vector2(0.,0.)
		else:
			speed -= speed.normalized() * delta_60 * real_air_friction
#non state physics functions
func set_delta():
	delta_60 = get_process_delta_time() * 60.
#processes
func _process(delta):
	set_delta()
	run_physics_states()
 
