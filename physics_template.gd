extends physics
#processes
func _ready():
	set_collision_polygons()
func _process(delta):
	set_process_delta()
func _physics_process(delta):
	default_physics_process()
