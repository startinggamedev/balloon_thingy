extends "res://templates/bodies/projectile_template.gd"
#export vars
@export var max_homing_distance = INF
func _ready():
	default_ready()
	default_bullet_ready()
	states["homing"] = "homing"
	current_state = "homing"
#state functions
func homing():
	direction = globals.get_nearest_node_in_group_angle("balloon_group",global_position,max_homing_distance)
func _process(delta):
	default_process()
func _physics_process(delta):
	default_physics_process()
