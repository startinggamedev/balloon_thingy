extends Node
#global vars
var ping_pong_var = null
var i = 0.
var n = 1.
var nearest_node = null
var return_vector = Vector2(0.,0.)
var screen_dimensions = Vector2(427.,240.)
var priority = [-1,0,1,2]
var mouse_pos = Vector2(0.,0.)
var shooting_key = "right_mouse"
#global functions
#delta functions
func delta_lerp(a,b,c,delta_60):
	return lerp(a,b,1. - pow(c,delta_60/60.))
func get_physics_delta_60():
	return (get_physics_process_delta_time() * 60.)
func get_delta_60():
	return (get_process_delta_time() * 60.)
#angle functions
func radian_to_vector(degree_to_convert):
	return Vector2(cos(degree_to_convert),sin(degree_to_convert))
func degree_to_vector(degree_to_convert):
	return Vector2(cos(deg_to_rad(degree_to_convert)),sin(deg_to_rad(degree_to_convert)))
func contain_angle_360(angle):
	return fmod(angle,360.)
func contain_radian_2PI(radian):
	return fmod(radian,2. * PI)
func get_random_angle():
	return randf_range(0.,360.)
func get_cursor_angle_vector(comparision_position,scale):
	return (globals.mouse_pos - comparision_position).normalized() * scale
func get_points_angle_vector(center_point,external_point):
	return (external_point - center_point).normalized()
func get_points_angle(center_point,external_point):
	return rad_to_deg((external_point - center_point).angle())
func get_cursor_angle_degrees(comparision_position):
	return get_points_angle(comparision_position,mouse_pos)
func clamp_radian(radian,mini,maxi):
	radian = contain_radian_2PI(radian)
	maxi = contain_radian_2PI(maxi)
	mini = contain_radian_2PI(mini)
	var radian_regulator = sign(radian) * 2. * PI
	maxi = contain_radian_2PI(maxi + radian_regulator)
	mini = contain_radian_2PI(mini + radian_regulator)
	if mini > maxi:
		ping_pong_var = maxi
		maxi = mini
		mini = ping_pong_var
	if mini > radian: print({"mini" = mini, "maxi" = maxi,"radian" = radian})
	radian = clamp(radian,mini,maxi)
	return radian
#get nearest functions
func get_nearest_node(node_list,comparision_position,max_search_distance):
	nearest_node = node_list[0]
	while n < len(node_list):
		if nearest_node.global_position.distance_to(comparision_position) > node_list[n].global_position.distance_to(comparision_position):
			nearest_node = node_list[n]
		n+=1
	n = 1
	if nearest_node.global_position.distance_to(comparision_position) <= max_search_distance:
		return nearest_node
	else:
		return null
func get_nearest_node_in_group(group,comparision_position,max_search_distance):
	return get_nearest_node(get_tree().get_nodes_in_group(group),comparision_position,max_search_distance)
func get_nearest_node_in_group_angle(group,comparision_position,max_search_distance):
	var my_nearest_node = globals.get_nearest_node_in_group(group,comparision_position,max_search_distance)
	if my_nearest_node:
		return get_points_angle(comparision_position,my_nearest_node.global_position)
	else: return null
#trigonometry
func law_of_cosines(a,b,theta):
	return sqrt((pow(a,2.) + pow(b,2.)) - (2. * b * a * cos(theta)))
#math
func clamp_vector(Vector,min_length,max_length):
	if Vector.length() > max_length:
		return Vector.normalized() * max_length
	elif Vector.length() < min_length:
		return Vector.normalized() * min_length
	else:
		return Vector
