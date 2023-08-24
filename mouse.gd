extends Node2D
@onready var mouse_sprite = %Sprite2D
#functions
func set_mouse_pos():
	global_position = get_global_mouse_position()
	global_position.x = clamp(global_position.x,0.,globals.screen_dimensions.x)
	global_position.y = clamp(global_position.y,0.,globals.screen_dimensions.y)
	globals.mouse_pos = global_position
	mouse_sprite.global_position = global_position
func _ready():
	process_priority = globals.priority[1]
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_mouse_pos()
