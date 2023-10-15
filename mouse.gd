extends Node2D
#functions
func set_mouse_pos():
	global_position = get_local_mouse_position()
	globals.mouse_pos = get_local_mouse_position()func _ready():
	process_priority = globals.priority[1]
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_mouse_pos()
