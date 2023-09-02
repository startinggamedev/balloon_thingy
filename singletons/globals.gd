extends Node
#global vars
var n = 1.
var nearest_node = null
var return_vector = Vector2(0.,0.)
var screen_dimensions = Vector2(427.,240.)
var priority = [-1,0,1,2]
var mouse_pos = Vector2(0.,0.)
#global functions
#delta functions
func delta_lerp(a,b,c,delta_60):
	return lerp(a,b,1. - pow(c,delta_60/60.))
func get_delta_60():
	return get_process_delta_time() * 60.
#angle functions
func get_random_angle():
	return randf_range(0.,360.)
func get_cursor_angle_vector(comparision_position,scale):
	return (globals.mouse_pos - comparision_position).normalized() * scale
func get_points_angle(center_point,external_point):
	return rad_to_deg((external_point - center_point).angle())
func get_cursor_angle_degrees(comparision_position):
	return get_points_angle(comparision_position,mouse_pos)
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
	return get_points_angle(comparision_position,globals.get_nearest_node_in_group(group,comparision_position,max_search_distance).global_position)
