extends CharacterBody2D
#variable resources
@export var air_fric_resource = Resource
@export var dir_resource = Resource
#onready vars
@onready var delta_60 = globals.get_delta_60()
@onready var speed = Vector2(0.,0.)
@onready var prev_global_position
@onready var real_air_friction = speed
#direction vars
@onready var direction_velocity = dir_resource.direction_velocity
@onready var direction = dir_resource.direction
@onready var direction_velocity_acceleration = dir_resource.direction_velocity_acceleration
@onready var angular_velocity = dir_resource.angular_velocity
#physics states vars
@onready var physics_states = {"normal_physics" : "normal_physics","intangible_physics" : "intangible_physics"}
@onready var current_physics_state = "normal_physics"
#air friction vars
@onready var air_fric = air_fric_resource.air_fric
@onready var min_air_fric = air_fric_resource.min_air_fric
@onready var max_air_fric = air_fric_resource.max_air_fric
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
func set_angle_speed():
	direction += angular_velocity * delta_60
	direction_velocity += direction_velocity_acceleration * delta_60
	return Vector2(cos(deg_to_rad(direction)),sin(deg_to_rad(direction))) * direction_velocity
func run_physics_states(): # run the physics states
	return call(physics_states[current_physics_state])
func collision(): #collide
	move_and_slide()
func manage_speed(): #move the body
	prev_global_position = global_position
	global_position += (speed + set_angle_speed()) * delta_60
func physics_return(): #what the physics states functions will return
	return global_position - prev_global_position
func manage_air_friction():
	if !air_fric: return
	real_air_friction = air_fric * speed.length() * delta_60
	real_air_friction = clamp(real_air_friction,min_air_fric * delta_60,max_air_fric * delta_60)
	if !is_on_floor():
		if speed.length() < abs(real_air_friction):
			speed = Vector2(0.,0.)
		else:
			speed -= speed.normalized() * real_air_friction 
#non state physics functions
func set_delta():
	delta_60 = globals.get_delta_60()
#processes
func _process(delta):
	set_delta()
	run_physics_states()
 
