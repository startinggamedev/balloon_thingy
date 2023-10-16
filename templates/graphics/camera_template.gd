extends Node2D
@onready var camera_template = $camera_template
func ready():
	process_priority = globals.priority[0]
func _process(delta):
	global_position = Vector2(0.,0.)
	var io = Vector2(get_viewport().get_visible_rect().size) / Vector2(320 * 2.,180. * 2. )
	camera_template.zoom = Vector2(io)
