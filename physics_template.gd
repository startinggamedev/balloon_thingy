extends CharacterBody2D
#variable resources
@export var dir_res = Resource
@export var air_fric_resource = Resource
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
@onready var linear_speed_dict = {"motion_forces" = Vector2(0.,0.),"angle_speed" = Vector2(0.,0.)}
#point
@onready var speed_point = Vector2(0.,0.)
#misc vars
@onready var i = 0
@onready var delta_60 = globals.get_delta_60()
@onready var speed = Vector2(0.,0.)
@onready var prev_global_position = Vector2(0.,0.)
@onready var real_air_friction = speed
#direction vars
@onready var target_direction_velocity = dir_res.target_direction_velocity
@onready var direction = dir_res.direction
@onready var direction_velocity_acceleration = dir_res.direction_velocity_acceleration
@onready var angular_velocity = dir_res.angular_velocity
#physics states vars
@onready var physics_states = {"normal_physics" : "normal_physics","intangible_physics" : "intangible_physics"}
@onready var current_physics_state = "normal_physics"
@onready var current_physics_logic_state = ""
#weight var
@export var bumpable = true
#colliding bodies vars
@onready var colliding_bodies = null
@onready var current_colliding_body = null
@onready var previous_colliding_body = null
#colliding motion forces vars
@onready var colliding_motion_forces = null
@onready var motion_to_add = Vector2(0.,0.)
# debug functions
func debug_process_delta():
	Engine.max_fps = abs(sin(Time.get_ticks_msec() / 720.)) * 60.
func debug_physics_delta():
	Engine.physics_ticks_per_second = abs(sin(Time.get_ticks_msec() / 720.)) * 60.
#physics states
func normal_physics(): #normal
	get_colliding_body()
	apply_bump()
	apply_motion_forces()
	manage_speed()
	move_and_collide(speed,false,0.1,true)
	return physics_return()
func intangible_physics(): #intangible
	manage_speed()
	move()
	return physics_return()
#physics states functions
#speed managers 
func move():
	global_position += speed
func add_extra_speed_point(extra_speed):
	speed_point += extra_speed
func add_speed_dict_entry(dict_entry_array):
	for i in range(len(dict_entry_array)):
		linear_speed_dict[dict_entry_array[i]] = Vector2(0.,0.)
func add_extra_speed(extra_speed):
		speed_linear += extra_speed
func set_linear_speed(speed_dict_entry,accel,direction,minimum,maximum,is_accelerating,smoothing = 0.):
	if is_accelerating:
		# the direction of the linear speed vector, the angle aceleration corresponds to the weight of the direction argument
		#the angle vector mutiplied the length of the speed plus aceleration
		linear_speed_dict[speed_dict_entry] += accel * delta_60 * direction
	else:
		linear_speed_dict[speed_dict_entry] = manage_air_friction(linear_speed_dict[speed_dict_entry])
	linear_speed_dict[speed_dict_entry] = globals.clamp_vector(linear_speed_dict[speed_dict_entry],minimum,maximum)
	add_extra_speed(linear_speed_dict[speed_dict_entry])
func set_angle_speed():
	direction += angular_velocity * delta_60
	set_linear_speed("angle_speed",direction_velocity_acceleration,globals.degree_to_vector(direction),0.,target_direction_velocity,true)
func manage_air_friction(base_speed):
	if abs(base_speed.length()) - abs(air_fric_resource.air_fric) < 0:
		return Vector2(0.,0.) 
	return base_speed - base_speed.normalized() * air_fric_resource.air_fric * delta_60
func manage_speed(): #move the body
	set_angle_speed()
	prev_global_position = global_position
	#linear
	speed = Vector2(0.,0.)
	speed += speed_linear * delta_60
	speed_linear = Vector2(0.,0.)
	#point
	speed += speed_point * delta_60
	speed_point = manage_air_friction(speed_point)
func get_bump():
	return clamp(current_colliding_body.speed.length()/delta_60,1.,10.) * -1 * globals.get_points_angle_vector(global_position,current_colliding_body.global_position) * (current_colliding_body.weight_res.weight/weight_res.weight)
func apply_bump():
	if current_colliding_body:
		if bumpable and current_colliding_body.bumpable:
			if current_colliding_body != previous_colliding_body:
				add_extra_speed_point(get_bump())
func apply_motion_forces():
	colliding_motion_forces = motion_force_detector.get_overlapping_areas()
	for i in len(colliding_motion_forces):
		motion_to_add += get_motion_force(colliding_motion_forces[i].current_motion_force_type)
	set_linear_speed("motion_forces",spd_res.acceleration,motion_to_add.normalized(),0.,motion_to_add.length(),true)
	motion_to_add = Vector2(0.,0.)
func get_motion_force(motion_force_type):
	if motion_force_type == "attraction":
		return  colliding_motion_forces[i].motion_force_scale * (globals.get_points_angle_vector(global_position,colliding_motion_forces[i].global_position)) + (globals.get_points_angle_vector(global_position,colliding_motion_forces[i].global_position).rotated(deg_to_rad(colliding_motion_forces[i].motion_direction))).normalized()
	if motion_force_type == "direction":
		return Vector2(cos(deg_to_rad(colliding_motion_forces[i].motion_direction)),sin(deg_to_rad(colliding_motion_forces[i].motion_direction))) * colliding_motion_forces[i].motion_force_scale
#wandering function
func orbit_wandering(orbit_center,orbit_radius,orbit_angle_speed):
	orbit_angle_speed = deg_to_rad(orbit_angle_speed)
	var max_orbit_speed = globals.law_of_cosines(orbit_radius,orbit_radius,orbit_angle_speed)
	var distance_to_orbit_center = global_position - orbit_center
	var targ_orbit_vector = orbit_center + (distance_to_orbit_center.normalized() * orbit_radius).rotated(orbit_angle_speed)
	var orbit_speed_to_add = globals.clamp_vector(targ_orbit_vector - global_position,0.,max_orbit_speed)
	add_extra_speed(orbit_speed_to_add/delta_60)
func arc_wandering(point1,point2,arc_opening_angle,arc_angle_speed):
	arc_angle_speed = deg_to_rad(arc_angle_speed)
	var p1_p2_arc_ang = point1.angle_to_point(point2)
	var middle_point_p1p2 = lerp(point1,point2,0.5)
	var p1_p2_arc_dif = point2 - point1
	var arc_center_vector = globals.degree_to_vector(90. - arc_opening_angle/2.)
	arc_center_vector = arc_center_vector * ((p1_p2_arc_dif.length()/2.) /  arc_center_vector.x)
	arc_center_vector = arc_center_vector.rotated(p1_p2_arc_ang) + point1
	var distance_to_arc_center = global_position - arc_center_vector 
	var arc_radius = (arc_center_vector - point1).length()
	var max_speed = globals.law_of_cosines(arc_radius,arc_radius,arc_angle_speed)
	var targ_arc_angle = arc_angle_speed * delta_60 + distance_to_arc_center.angle() 
	targ_arc_angle = globals.radian_to_vector(targ_arc_angle)
	var targ_arc_orbit_vector = arc_center_vector + targ_arc_angle * arc_radius 
	if global_position.distance_to(point2) <= max_speed:
		targ_arc_orbit_vector = point2
	var speed_to_add = (targ_arc_orbit_vector - global_position)
	speed_to_add = globals.clamp_vector(speed_to_add,0.,max_speed)
	add_extra_speed(speed_to_add/delta_60)
func line_wandering(point1,point2,max_line_speed):
	var gprp1 = global_position - point1 # Global Position Relative to Point 1
	var p2p1 = point2 - point1 # Point2 relative to Point1
	var proj = (gprp1).project(p2p1) # global pos projected on the line
	var ang_relative_to_p2 = (p2p1 - gprp1).normalized()
	var p2_dis = clamp((p2p1 - gprp1).length(),0.,max_line_speed) # attraction to the line's end
	var line_offset = globals.clamp_vector(proj - gprp1,0.,max_line_speed)
	var final_line_wandering_vector = ang_relative_to_p2 * p2_dis + line_offset
	#set_linear_speed("line_wandering",accel,final_line_wandering_vector,0.,final_line_wandering_vector.length(),true)
	add_extra_speed(final_line_wandering_vector)#set_linear_speed("line_wandering",accel,Vector2(cos(point1.angle_to_point(point2)),sin(point1.angle_to_point(point2))),0,target_speed,is_accelerating)
#state machine managers
func run_physics_logic_states():
	if current_physics_logic_state != "":
		return call(current_physics_logic_state)
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
func set_physics_delta():
	delta_60 = globals.get_physics_delta_60()
func set_process_delta():
	delta_60 = globals.get_delta_60()
#onready functions-+
func set_collision_polygons():
	bump_collision_polygon.polygon = collision_polygon.polygon
	motion_force_collision_polygon.polygon = collision_polygon.polygon
#default processes
func default_physics_process():
	set_physics_delta()
	run_physics_logic_states()
	run_physics_states()
#processes
func _ready():
	set_collision_polygons()
func _process(delta):
	set_process_delta()
func _physics_process(delta):
	default_physics_process()
