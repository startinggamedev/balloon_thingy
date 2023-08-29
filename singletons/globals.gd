extends Node
var n = 1.
var nearest_node = null
var return_vector = Vector2(0.,0.)
var screen_dimensions = Vector2(427.,240.)
var priority = [-1,0,1,2]
var mouse_pos = Vector2(0.,0.)
func delta_lerp(a,b,c,delta_60):
	return lerp(a,b,1. - pow(c,delta_60/60.))
func get_delta_60():
	return get_process_delta_time() * 60.
func get_random_angle():
	return randf_range(0.,360.)
func get_cursor_angle_vector(comparision_position,scale):
	return (globals.mouse_pos - comparision_position).normalized() * scale
func get_cursor_angle_degrees(comparision_position):
	return rad_to_deg((globals.mouse_pos - comparision_position).angle())
func get_nearest_node(node_list,comparision_position):
	nearest_node = node_list[0]
	while n < len(node_list):
		if nearest_node.global_position.distance_to(comparision_position) > node_list[n].global_position.distance_to(comparision_position):
			nearest_node = node_list[n]
		n+=1
	n = 1
	return nearest_node

