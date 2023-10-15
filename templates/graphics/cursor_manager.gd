extends Node2D
func _process(delta):
	globals.mouse_pos = get_global_mouse_position()
	global_position = globals.mouse_pos
