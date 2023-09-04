extends CharacterBody2D
#variable resources
@export var air_fric_resource = Resource
@export var dir_resource = Resource
@export var spd_res = Resource
@export var weight_res = Resource
#onready vars
#speed
#linear
@onready var speed_linear = Vector2(0.,0.)
@onready var linear_speed_dict = {}
#point
@onready var speed_point = Vector2(0.,0.)
#misc vars
@onready var i = 0
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
#speed var
@onready var acceleration = spd_res.acceleration
#weight var
@onready var weight = weight_res.weight
#colliding bodies vars
@onready var colliding_bodies = null
@onready var colliding_body_to_check = 0.
@onready var current_colliding_body = null
@onready var previous_colliding_body = null
# functions
#physics states
func normal_physics(): #normal
	set_angle_speed()
	manage_speed()
	collision()
	return physics_return()
func intangible_physics(): #intangible
	manage_speed()
	return physics_return()
#physics states functions
#speed managers
func add_extra_speed_point(extra_speed):
	speed_point += extra_speed
func add_speed_dict_entry(dict_entry_array):
	for i in range(len(dict_entry_array)):
		linear_speed_dict[dict_entry_array[i]] = Vector2(0.,0.)
func add_extra_speed(extra_speed):
		speed_linear += extra_speed
func set_linear_speed(speed_dict_entry,accel,direction,minimum,maximum,is_accelerating):
	if is_accelerating:
		linear_speed_dict[speed_dict_entry] += accel  * direction * delta_60
	else:
		linear_speed_dict[speed_dict_entry] = manage_air_friction(linear_speed_dict[speed_dict_entry])
	linear_speed_dict[speed_dict_entry] = globals.clamp_vector(linear_speed_dict[speed_dict_entry],minimum,maximum)
	add_extra_speed(linear_speed_dict[speed_dict_entry])
func set_angle_speed():
	direction += angular_velocity * delta_60
	direction_velocity += direction_velocity_acceleration * delta_60
	add_extra_speed(Vector2(cos(deg_to_rad(direction)),sin(deg_to_rad(direction))) * direction_velocity)
func manage_air_friction(base_speed):
	if abs(base_speed.length()) - abs(air_fric) < 0:
		return Vector2(0.,0.) 
	return base_speed - base_speed.normalized() * air_fric * delta_60
func manage_speed(): #move the body
	prev_global_position = global_position
	#linear
	global_position += speed_linear * delta_60
	speed_linear = Vector2(0.,0.)
	#point
	global_position += speed_point * delta_60
	speed_point = manage_air_friction(speed_point)
	speed = global_position - prev_global_position
#state machine managers
func run_physics_states(): # run the physics states
	colliding_bodies = 
	return call(physics_states[current_physics_state])
func collision(): #collide
	move_and_slide()
func physics_return(): #what the physics states functions will return
	return global_position - prev_global_position
#non state physics functions
func set_delta():
	delta_60 = globals.get_delta_60()
#processes
func _process(delta):
	set_delta()
	run_physics_states()
 
