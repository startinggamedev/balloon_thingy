extends CharacterBody2D
#variable resources
@export var air_fric_resource = Resource
@export var dir_resource = Resource
@export var spd_res = Resource
@export var weight_res = Resource
#onready vars
#child nodes
#collision detectors
@onready var bump_detector = $bump_detector
@onready var motion_force_detector = $motion_force_detector
#collision polygons
@onready var collision_polygon = $collision_polygon
@onready var bump_collision_polygon = $bump_detector/bump_collision_polygon
@onready var motion_force_collision_polygon = $motion_force_detector/motion_force_collision_polygon
#speed
#linear
@onready var speed_linear = Vector2(0.,0.)
@onready var linear_speed_dict = {"motion_forces" = Vector2(0.,0.)}
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
@onready var bumpable = true
@onready var weight = weight_res.weight
#colliding bodies vars
@onready var colliding_bodies = null
@onready var current_colliding_body = null
@onready var previous_colliding_body = null
#colliding motion forces vars
@onready var colliding_motion_forces = null
@onready var motion_to_add = Vector2(0.,0.)
# functions
#physics states
func normal_physics(): #normal
	get_colliding_body()
	set_angle_speed()
	apply_bump()
	apply_motion_forces()
	manage_speed()
	move_and_collide(speed,false,0.3,true)
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
	linear_speed_dict[speed_dict_entry] = globals.clamp_vector(linear_speed_dict[speed_dict_entry],minimum,INF)
	if linear_speed_dict[speed_dict_entry].length() > maximum:
		linear_speed_dict[speed_dict_entry] = linear_speed_dict[speed_dict_entry].move_toward(linear_speed_dict[speed_dict_entry].normalized() * maximum,accel * delta_60)
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
	speed = Vector2(0.,0.)
	speed += speed_linear * delta_60
	speed_linear = Vector2(0.,0.)
	#point
	speed += speed_point * delta_60
	speed_point = manage_air_friction(speed_point)
func get_bump():
	return clamp(current_colliding_body.speed.length(),1.,10.) * -1 * globals.get_points_angle_vector(global_position,current_colliding_body.global_position) * (current_colliding_body.weight/weight)
func apply_bump():
	if current_colliding_body:
		if bumpable and current_colliding_body.bumpable:
			if current_colliding_body != previous_colliding_body:
				add_extra_speed_point(get_bump())
func apply_motion_forces():
	colliding_motion_forces = motion_force_detector.get_overlapping_areas()
	for i in len(colliding_motion_forces):
		motion_to_add += get_motion_force(colliding_motion_forces[i].current_motion_force_type)
	set_linear_speed("motion_forces",acceleration,motion_to_add.normalized(),0.,motion_to_add.length(),true)
	motion_to_add = Vector2(0.,0.)
func get_motion_force(motion_force_type):
	if motion_force_type == "attraction":
		return  colliding_motion_forces[i].motion_force_scale * (globals.get_points_angle_vector(global_position,colliding_motion_forces[i].global_position)) + (globals.get_points_angle_vector(global_position,colliding_motion_forces[i].global_position).rotated(deg_to_rad(colliding_motion_forces[i].motion_direction))).normalized()
	if motion_force_type == "direction":
		return Vector2(cos(deg_to_rad(colliding_motion_forces[i].motion_direction)),sin(deg_to_rad(colliding_motion_forces[i].motion_direction))) * colliding_motion_forces[i].motion_force_scale
#state machine managers
func run_physics_states(): # run the physics states
	return call(physics_states[current_physics_state])
func get_colliding_body():
	previous_colliding_body = current_colliding_body
	colliding_bodies = bump_detector.get_overlapping_bodies()
	if colliding_bodies: 
		if colliding_bodies[0].get_instance_id() != get_instance_id():
			current_colliding_body = colliding_bodies[0]
		elif len(colliding_bodies) > 1:
			current_colliding_body = colliding_bodies[1]
		else:
			current_colliding_body = null
	else: current_colliding_body = null
func physics_return(): #what the physics states functions will return
	return global_position - prev_global_position
#non state physics functions
func set_delta():
	delta_60 = globals.get_delta_60()
#onready functions-+
func set_collision_polygons():
	bump_collision_polygon.polygon = collision_polygon.polygon
	motion_force_collision_polygon.polygon = collision_polygon.polygon
#default processes
func default_physics_process():
	run_physics_states()
#processes
func _ready():
	set_collision_polygons()
func _process(delta):
	set_delta()
func _physics_process(delta):
	default_physics_process()
