extends state
func process(delta_60):
	pass
func physics_process(delta_60):
	actor.arc_wandering(Vector2(100.,100.),Vector2(200.,100.),360.,1.)
